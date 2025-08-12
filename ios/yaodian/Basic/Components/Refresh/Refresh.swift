//
//  Refresh.swift
//  Basic
//
//  Created by wangteng on 2023/3/26.
//

import Foundation
import MJRefresh

extension UITableView {
    
    func setupHeaderRefresh(block: @escaping ()-> Void) {
        let header = BasicRefreshHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("刷新中", for: .refreshing)
        header.setTitle("下拉刷新", for: .idle)
        header.stateLabel?.font = UIFont.systemFont(ofSize: 14, weight:.regular)
        self.mj_header = header
    }
    
    func stopRefreshing() {
        self.mj_header?.endRefreshing()
        self.mj_footer?.endRefreshing()
    }
    
    func setupFooterRefresh(block: @escaping ()->()) {
        let footer = MJRefreshBackGifFooter(refreshingBlock: block)
        footer.setTitle("", for: .noMoreData)
        footer.stateLabel?.textColor = UIColor(0xCCCCCC)
        footer.stateLabel?.font = UIFont.systemFont(ofSize: 12)
        self.mj_footer = footer
    }
}

extension UICollectionView {
    
    func setupHeaderRefresh(block: @escaping ()-> Void) {
        let header = BasicRefreshHeader(refreshingBlock: block)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle("松开刷新", for: .pulling)
        header.setTitle("刷新中", for: .refreshing)
        header.setTitle("下拉刷新", for: .idle)
        header.stateLabel?.textColor = .barTintColor
        header.stateLabel?.font = UIFont.systemFont(ofSize: 14, weight:.regular)
        self.mj_header = header
    }
    
    func stopRefreshing() {
        self.mj_header?.endRefreshing()
    }
}
