
import UIKit

@objc public protocol WaterLayoutDelegate: NSObjectProtocol {
    
    func collectionView(_ layout: WaterLayout,
                        heightForItemAt indexPath: IndexPath) -> CGFloat
    
    @objc optional
    func collectionView(_ layout: WaterLayout,
                        heightForHeader section: Int) -> CGFloat

    @objc optional
    func collectionView(_ layout: WaterLayout,
                        heightForFooter section: Int) -> CGFloat
}

open class WaterLayout: UICollectionViewLayout {

    @objc public weak var delegate: WaterLayoutDelegate?
    
    @objc open var minimumLineSpacing: CGFloat = 0

    @objc open var minimumInteritemSpacing: CGFloat = 0
    
    @objc open var contentInset: UIEdgeInsets = .zero
    
    @objc open var columnCount = 2
    
    @objc open var layoutCompletion: (() -> Void)?
    
    private var attributesList: [UICollectionViewLayoutAttributes] = []
    private var columnHeights: [CGFloat] = []
    
    @objc public var maxHeight: CGFloat = 0.0
    
    private var visibleWidth: CGFloat {
        guard let collectionView = self.collectionView else {
            return 0
        }
        return collectionView.bounds.size.width
            - (contentInset.left
            + contentInset.right)
    }
    
    override open func prepare() {
        super.prepare()
        computeAttributes()
    }
    
    private func computeAttributes() {
        attributesList.removeAll()
        columnHeights.removeAll()
        guard let collectionView = self.collectionView else {
            return
        }
        for _ in 0..<columnCount {
            columnHeights.append(contentInset.top)
        }
       
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            let sectionHeaderIndexPath = IndexPath(item: 0, section: section)
            if let supplementaryAttrtibute = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: sectionHeaderIndexPath) {
                attributesList.append(supplementaryAttrtibute)
            }
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for idx in 0..<numberOfItems {
                let indexPath = IndexPath.init(row: idx, section: section)
                if let arrtibutes = self.layoutAttributesForItem(at: indexPath) {
                    attributesList.append(arrtibutes)
                }
            }
            if let supplementaryAttrtibute = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: sectionHeaderIndexPath) {
                attributesList.append(supplementaryAttrtibute)
            }
        }
      
        self.maxHeight = columnHeights.max() ?? 0
        self.maxHeight += (contentInset.top + contentInset.bottom)
        self.layoutCompletion?()
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let delegate = delegate else {
            return layoutAttributes
        }
        let itemHeight = delegate.collectionView(self, heightForItemAt: indexPath)
        let totalLineSpacing = (CGFloat((columnCount+1))*minimumInteritemSpacing)
        let itemWidth = (visibleWidth-totalLineSpacing)/CGFloat(columnCount)
        let column = minColumn()
        let left = (minimumInteritemSpacing+itemWidth)*CGFloat(column)+minimumInteritemSpacing+contentInset.left
        let top = columnHeights[column] + minimumLineSpacing
        let frame = CGRect(x: left, y: top, width: itemWidth, height: itemHeight)
        layoutAttributes.frame = frame
        columnHeights[column] = layoutAttributes.height
        return layoutAttributes
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            guard let delegate = delegate else {
                return nil
            }
            let height = delegate.collectionView?(self, heightForHeader: indexPath.section) ?? 0
            if height <= 0 {
                return nil
            }
            let sectionHeaderAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            let column = maxColumn()
           
            let top = columnHeights[column]
            let frame = CGRect(x: contentInset.left, y: top, width: visibleWidth, height: height)
            sectionHeaderAttribute.frame = frame
            for idx in 0..<columnCount {
                columnHeights[idx] = sectionHeaderAttribute.height
            }
            return sectionHeaderAttribute
        case UICollectionView.elementKindSectionFooter:
            guard let delegate = delegate else {
                return nil
            }
           
            let height = delegate.collectionView?(self, heightForFooter: indexPath.section) ?? 0
            if height <= 0 {
                return nil
            }
            let sectionFooterAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            let column = maxColumn()
            let top = columnHeights[column] + minimumInteritemSpacing
            let frame = CGRect(x: contentInset.left, y: top, width: visibleWidth, height: height)
            sectionFooterAttribute.frame = frame
            for idx in 0..<columnCount {
                columnHeights[idx] = sectionFooterAttribute.height
            }
            return sectionFooterAttribute
        default:
            return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }

    open override var collectionViewContentSize: CGSize {
        let height = maxHeight
        return CGSize(width: visibleWidth, height: height)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    private func minColumn() -> Int {
        if let minHeight = columnHeights.min(by: <) {
            for idx in 0..<columnCount where minHeight == columnHeights[idx] {
                return idx
            }
        }
        return 0
    }
    private func maxColumn() -> Int {
        if let minHeight = columnHeights.min(by: >) {
            for idx in 0..<columnCount where minHeight == columnHeights[idx] {
                return idx
            }
        }
        return 0
    }
}

fileprivate extension UICollectionViewLayoutAttributes {
    var height: CGFloat {
        return frame.origin.y + frame.height
    }
}
