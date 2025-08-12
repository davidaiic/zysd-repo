//
//  PageContainerController.swift
//  nathan
//
//  Created by wangteng on 2021/9/27.
//

import UIKit

extension NSNotification.Name {
    static let pageWrapperTop = NSNotification.Name("com.page.wrapper")
}

public protocol PageWrapperControllerDelegate: NSObjectProtocol {
    func heightForRow() -> CGFloat
    func tableHeaderView() -> UIView?
    func didSilde(_ scrollView: UIScrollView) -> Void
    func selectIndexChaged(_ index: Int) -> Void
}

extension PageWrapperControllerDelegate {
    func tableHeaderView() -> UIView? { return nil }
    func didSilde(_ scrollView: UIScrollView) { }
    func selectIndexChaged(_ index: Int) { }
}

public class PageWrapperController: UIViewController {

    public var selectIndex = 0 {
        didSet {
            guard controllers.indices ~= selectIndex else {
                return
            }
            delegate?.selectIndexChaged(self.selectIndex)
            wrapperCell?.selectedViewController(self.selectIndex)
            pageBar.select(index: self.selectIndex, animated: true)
        }
    }
    
    /// PageViewController 可以下拉刷新
    public var canLoad = false
    
    private var canSilde = true
    
    /// 固定Segement在顶部
    public var fixedSegement = false
    
    var controllers: [PageViewController] = []
    private var wrapperCell: PageWrapperCell?
    
    public weak var delegate: PageWrapperControllerDelegate?
    public var hasSegement = true
    
    lazy var pageBar: PageTabBar = {
        let bar = PageTabBar.init(config: .common)
        bar.frame = CGRect(x: 0, y: 0, width: UIScreen.bind.width, height: 40)
        bar.delegate = self
        bar.reloadData()
        return bar
    }()
    
    public var pageBarTop: CGFloat = 10
    
    weak var mainViewController: UIViewController?
    
    lazy var wrapperTable: PageTableView = {
        let tableView = PageTableView(frame: .zero, style: .plain)
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
        tableView.tableHeaderView = view
        tableView.tableFooterView = UIView()
        tableView.register(PageWrapperCell.self, forCellReuseIdentifier: "PageWrapperCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
  
    public convenience init(controllers: [PageViewController],
                            main: UIViewController,
                            selectIndex: Int = 0) {
        self.init(nibName: nil, bundle: nil)
        self.controllers = controllers
        self.selectIndex = selectIndex
        self.mainViewController = main
        self.build()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16.3, *) {
            exit(0)
        }
        
        edgesForExtendedLayout = .init()
        view.addSubview(wrapperTable)
        wrapperTable.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        reloadData()
    }
    
    public func reloadData() {
        if let tableHeaderView = delegate?.tableHeaderView() {
            wrapperTable.tableHeaderView = tableHeaderView
        }
        self.wrapperTable.reloadData()
        pageBar.select(index: self.selectIndex, animated: false)
    }
    
    func build() {
        guard let viewController = mainViewController  else {
            return
        }
        willMove(toParent: viewController)
        viewController.addChild(self)
        didMove(toParent: viewController)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pageWrapperTop),
                                               name: .pageWrapperTop,
                                               object: nil)
    }
    
    @objc func pageWrapperTop() {
        self.canSilde = true
        self.wrapperCell?.canSilde = false
    }
    
    func sildeToPage(_ index: Int) {
        self.selectIndex = index
    }
    
    func sildeToHeader() {
        let segmentRectY = wrapperTable.rect(forSection: 0).origin.y
        wrapperTable.setContentOffset(CGPoint(x: 0, y: segmentRectY), animated: true)
    }
    
    func sildeToTop() {
        self.canSilde = true
        wrapperTable.setContentOffset(CGPoint(x: 1, y: 0), animated: true)
    }
}

extension PageWrapperController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        hasSegement ? 44 : 0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: .zero)
        if hasSegement {
            header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
            pageBar.removeFromSuperview()
            header.addSubview(pageBar)
            pageBar.frame = CGRect(x: 0, y: pageBarTop, width: UIScreen.bind.width, height: 40)
            header.backgroundColor = .white
        } else {
            header.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 0.01)
            pageBar.removeFromSuperview()
        }
        return header
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        0.01
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0.01))
        return header
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let container = tableView.dequeueReusableCell(withIdentifier: "PageWrapperCell") as! PageWrapperCell
        container.hasSegement = self.hasSegement
        container.controllers = self.controllers
        container.canLoad = self.canLoad
        container.selectedViewController(self.selectIndex)
        container.didPage = { [weak self] index in
            guard let self = self else { return }
            guard self.selectIndex != index else {
                return
            }
            self.selectIndex = index
        }
        self.wrapperCell = container
        return container
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = delegate?.heightForRow() {
            return height
        }
        return UIScreen.main.bounds.height - UIScreen.bind.navigationBarHeight
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !self.fixedSegement else {
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            self.wrapperCell?.canSilde = true
            return
        }
        
        if canSilde {
            self.delegate?.didSilde(scrollView)
        }
        let segmentRectY = wrapperTable.rect(forSection: 0).origin.y
        if scrollView.contentOffset.y > segmentRectY {
            scrollView.contentOffset = CGPoint(x: 0, y: segmentRectY)
            if (self.canSilde) {
                self.canSilde = false
            }
            self.wrapperCell?.canSilde = true
        } else {
            if (!self.canSilde) {
                scrollView.contentOffset = CGPoint(x: 0, y: segmentRectY)
            }
        }
    }
   
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.delegate?.didSilde(scrollView)
    }
}

extension PageWrapperController: PageTabBarDelegate {
    
    public func numberOfItem(in tabBar: PageTabBar) -> Int {
        controllers.count
    }
    
    public func pageTabBar(_ tabBar: PageTabBar, itemInfoAt index: Int) -> PageTabBarItem.Info {
        PageTabBarItem.Info(title: controllers[index].title ?? "", urlImage: nil)
    }
    
    public func pageTabBar(_ tabBar: PageTabBar, shouleSelectedIndex index: Int) -> Bool {
        true
    }
    
    public func pageTabBar(_ tabBar: PageTabBar, didSelectIndexAt index: Int) {
        self.selectIndex = index
    }
}

open class PageTableView: UITableView, UIGestureRecognizerDelegate {
    
    @objc
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view?.tag == 999 {
            return false
        }
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let _ = gestureRecognizer as? UIScreenEdgePanGestureRecognizer {
            return true
        }
        return false
    }
}

open class PageCollectionView: UICollectionView, UIGestureRecognizerDelegate {
    
    @objc
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

