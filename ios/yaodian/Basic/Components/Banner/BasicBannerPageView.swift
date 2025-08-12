//
//  BaseBannerView.swift
//  Basic
//
//  Created by wangteng on 2023/3/11.
//

import Foundation

class BasicBannerPageView: BasicBannerView {
    
    enum PagePosition {
        case left, center, right
    }
    
    var selectedItemAtIndexPathHandler: ((Int) -> Void)?
    
    private(set) var page: BannerPageControl!
    
    private(set) var pagePosition: PagePosition!
    
    var items: [String] = [] {
        didSet {
           
            self.page.pageCount = itemCount
            self.page.isHidden = itemCount <= 1
            self.fixContentOffset()
            if itemCount > 1 {
                self.startAutoScroll()
            } else {
                self.stopAutoScroll()
            }
            self.collectionView.isScrollEnabled = self.items.count > 1
        }
    }
    
    init(perferSize: CGSize, page: BannerPageControl = FilledPageControl(),
         pagePosition: PagePosition = .right) {
        self.page = page
        self.pagePosition = pagePosition
        super.init(frame: .zero)
        self.bannerLayout.minimumLineSpacing = 0
        self.bannerLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.bannerLayout.itemSize = perferSize
        
        self.collectionView.register(BasicBannerPageViewImageCell.self, forCellWithReuseIdentifier: "BasicBannerPageViewImageCell")
        
        setupSnakePageControl()
    }
    
    private func setupSnakePageControl() {
        
        addSubview(page)
        switch self.pagePosition {
        case .left:
            page.snp.makeConstraints { make in
                make.bottom.equalTo(-10)
                make.left.equalTo(self.bannerLayout.sectionInset.left+10)
                make.height.equalTo(10)
            }
        case .right:
            page.snp.makeConstraints { make in
                make.bottom.equalTo(-10)
                make.right.equalTo(-self.bannerLayout.sectionInset.right-10)
                make.height.equalTo(10)
            }
        case .center:
            page.snp.makeConstraints { make in
                make.bottom.equalTo(-10)
                make.centerX.equalToSuperview()
                make.height.equalTo(10)
            }
        case .none:
            break
        }
    }
    
    override var timeInterval: TimeInterval {
        return 5.0
    }
    
    override var itemCount: Int {
        return self.items.count
    }
    
    override func progress(_ progress: CGFloat) {
        self.page.progress = progress
    }
    
    override func bannerCell(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BasicBannerPageViewImageCell", for: indexPath) as! BasicBannerPageViewImageCell
        let item = self.items[self.rawIndex(of: indexPath.row)]
        cell.imageView.kf.setImage(with: item.bind.url)
        return cell
    }
    
    override func didSelected(indexPath: IndexPath) {
        let index = self.rawIndex(of: indexPath.row)
        selectedItemAtIndexPathHandler?(index)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BasicBannerPageViewImageCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "background")
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addHierarchy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addHierarchy() {
        self.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
