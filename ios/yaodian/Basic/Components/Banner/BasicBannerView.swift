//
//  BannerView.swift
//  Basic
//
//  Created by wangteng on 2023/3/11.
//

import UIKit

public class BasicBannerView: UIView {
    
    private(set) var bannerLayout: UICollectionViewFlowLayout!
    private(set) var collectionView: UICollectionView!
    
    private var timer: Timer? = nil
    
    public var infiniteLoop = true
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
      
        self.bannerLayout = layout
        self.collectionView = collectionView
      
    }
    
    final public func fixContentOffset() {
        
        guard itemCount > 0 else { return }
        var targetIndex: Int = 0
        if (self.infiniteLoop) {
            targetIndex = Int(Float(self._itemCount) * 0.5)
        }
        self.collectionView.performBatchUpdates {
            self.collectionView.reloadData()
        } completion: { _ in
            self.scrollToItem(targetIndex)
        }
    }
    
    public var timeInterval: TimeInterval {
        return 3.0
    }
    
    public var itemCount: Int {
        fatalError()
    }
    
    public func bannerCell(at indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
    
    public func didSelected(indexPath: IndexPath) {
        
    }
    
    public func progress(_ progress: CGFloat) {
        
    }
    
    public func startAutoScroll() {
        guard self._itemCount > 0 else {
            return
        }
        self.startTimer()
    }
    
    public func stopAutoScroll() {
        self.stopTimer()
    }
    
    deinit {
        self.stopTimer()
    }
    

    private func scrollToItem(_ index: Int, animated: Bool = false) {
        
        guard self.itemCount > 0 else {
            return
        }
        
        self.collectionView.isPagingEnabled = false
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                    at: .centeredHorizontally, animated: animated)
        self.collectionView.isPagingEnabled = true
    }
}

extension BasicBannerView {
    
    private var _itemCount: Int {
        return infiniteLoop ? self.itemCount*100 : self.itemCount
    }
}

extension BasicBannerView {
    
    public func startTimer() {
        self.stopTimer()
        let timer = Timer(timeInterval: self.timeInterval, repeats: true) { [weak self] _ in
            guard let self = self, self._itemCount > 0  else {
                return
            }
            let nextIndex = self.caculateIndex()+1
            self.scrollToIndex(nextIndex)
        }
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }
    
    public func stopTimer() {
        guard let timer = self.timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }
    
    public func scrollToIndex(_ index: Int) {
        if index >= _itemCount {
            if infiniteLoop {
                self.scrollToItem(targetIndex())
            }
            return
        }
        self.scrollToItem(index, animated: true)
    }
    
    public func targetIndex() -> Int {
        Int(Float(self._itemCount) * 0.5)
    }
}

extension BasicBannerView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func caculateIndex() -> Int {
        let bounds = self.collectionView.bounds
        if bounds.width == 0 || bounds.height == 0 {
            return 0
        }
        var index: Int = 0
        switch bannerLayout.scrollDirection {
        case .horizontal:
            let width = (bannerLayout.itemSize.width + bannerLayout.minimumLineSpacing)
            index = Int((collectionView.contentOffset.x + width * 0.5) / width)
        case .vertical:
            index = Int((collectionView.contentOffset.y + bannerLayout.itemSize.height*0.5) / bannerLayout.itemSize.height)
        @unknown default:
            break
        }
        return Int(max(0, index))
    }
    
    final func rawIndex(of index: Int) -> Int {
        return index % self.itemCount
    }
    
    final public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self._itemCount
    }
    
    final public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.bannerCell(at: indexPath)
    }
    
    final public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelected(indexPath: indexPath)
    }
    
    final public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    final public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.startAutoScroll()
    }
    
    final public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    }
    
    final public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        triggerProgressHandler()
    }
    
    public func triggerProgressHandler() {
        guard itemCount > 0 else { return }
        let width = (bannerLayout.itemSize.width + bannerLayout.minimumLineSpacing)
        let progress = (collectionView.contentOffset.x/width)
        let count = Int(progress) % itemCount
        
        let number = progress - CGFloat(Int(progress))
        let value = number+CGFloat(count)
        self.progress(value)
    }
}

