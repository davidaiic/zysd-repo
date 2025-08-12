
import UIKit

public extension TagLayout {
    
    @objc func heightForItems(sizes: [CGSize], maxWidth: CGFloat) -> CGFloat {
  
        var frame: CGRect = .zero
        sizes.forEach {
            frame = self.dealAttributesForItem(at: $0, maxWidth: maxWidth, outFrame: frame)
        }
        return frame.height + frame.origin.y
    }
    
    private func dealAttributesForItem(at itemSize: CGSize,
                                       maxWidth: CGFloat,
                                       outFrame: CGRect) -> CGRect {
        var dealFrame: CGRect = .zero
        var left = minimumInteritemSpacing
        var top = minimumLineSpacing
        if (outFrame.origin.x + outFrame.width + minimumInteritemSpacing*2 + itemSize.width) <= maxWidth {
            left = outFrame.origin.x + outFrame.width + minimumInteritemSpacing
            top = outFrame.origin.y
        } else {
            top = outFrame.origin.y + outFrame.height + minimumLineSpacing
        }
        dealFrame = CGRect(x: left, y: top, width: itemSize.width, height: itemSize.height)
        return dealFrame
    }
}

@objc public protocol TagLayoutDelegate: NSObjectProtocol {
    
    func collectionView(_ layout: TagLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    
    @objc optional
    func collectionView(_ layout: TagLayout,
                        heightForHeader section: Int) -> CGFloat

    @objc optional
    func collectionView(_ layout: TagLayout,
                        heightForFooter section: Int) -> CGFloat
}

open class TagLayout: UICollectionViewLayout {
    
    @objc public weak var delegate: TagLayoutDelegate?
    
    @objc
    open var minimumLineSpacing: CGFloat = 0
    
    @objc
    open var minimumInteritemSpacing: CGFloat = 0
    
    private var attributesList: [UICollectionViewLayoutAttributes] = []
    private var tailAttributes = UICollectionViewLayoutAttributes()
    
    private var visibleWidth: CGFloat {
        guard let collectionView = self.collectionView else {
            return 0
        }
        return collectionView.bounds.size.width
            - (collectionView.contentInset.left
                + collectionView.contentInset.right)
    }
    
    override open func prepare() {
        super.prepare()
        layoutAttributes()
    }
    
    private func layoutAttributes() {
        guard let collectionView = self.collectionView else { return }
        attributesList.removeAll()
        tailAttributes.frame = .zero
        let numberOfSections = collectionView.numberOfSections
        for section in 0..<numberOfSections {
            let sectionIndexPath = IndexPath(item: 0, section: section)
            if let supplementaryAttrtibute = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: sectionIndexPath) {
                attributesList.append(supplementaryAttrtibute)
            }
            let numberOfItems = collectionView.numberOfItems(inSection: section)
            for idx in 0..<numberOfItems {
                let indexPath = IndexPath.init(row: idx, section: section)
                if let arrtibutes = self.layoutAttributesForItem(at: indexPath) {
                    attributesList.append(arrtibutes)
                }
            }
            if let supplementaryAttrtibute = self.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: sectionIndexPath) {
                attributesList.append(supplementaryAttrtibute)
            }
        }
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let delegate = delegate else {
            return layoutAttributes
        }
        let itemSize = delegate.collectionView(self, sizeForItemAt: indexPath)
        var left = minimumInteritemSpacing
        var top = minimumLineSpacing
        if (tailAttributes.width + minimumInteritemSpacing*2 + itemSize.width) <= visibleWidth {
            left = tailAttributes.width + minimumInteritemSpacing
            top = tailAttributes.frame.origin.y
        } else {
            top = tailAttributes.height + minimumLineSpacing
        }
        let frame = CGRect(x: left, y: top, width: itemSize.width, height: itemSize.height)
        layoutAttributes.frame = frame
        tailAttributes.frame = frame
        return layoutAttributes
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            let header = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            let height = delegate?.collectionView?(self, heightForHeader: indexPath.section) ?? 0
            if height <= 0 {
                return nil
            }
            let frame = CGRect(x: 0,
                               y: tailAttributes.height,
                               width: visibleWidth, height: height)
            header.frame = frame
            tailAttributes.frame = frame
            return header
        case UICollectionView.elementKindSectionFooter:
            let footer = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
            let height = delegate?.collectionView?(self, heightForFooter: indexPath.section) ?? 0
            if height <= 0 {
                return nil
            }
            let frame = CGRect(x: 0,
                               y: tailAttributes.height+minimumLineSpacing,
                               width: visibleWidth, height: height)
            footer.frame = frame
            tailAttributes.frame = frame
            return footer
        default:
            return nil
        }
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesList
    }
    
    open override var collectionViewContentSize: CGSize {
        return CGSize(width: visibleWidth, height: tailAttributes.height)
    }
}

fileprivate extension UICollectionViewLayoutAttributes {
    
    var width: CGFloat {
        return frame.origin.x + frame.width
    }
    var height: CGFloat {
        return frame.origin.y + frame.height
    }
}
