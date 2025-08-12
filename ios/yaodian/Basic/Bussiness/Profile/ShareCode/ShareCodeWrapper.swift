//
//  ShareCodeWrapper.swift
//  Basic
//
//  Created by wangteng on 2023/4/15.
//

import Foundation

class ShareCodeWrapper: BaseViewController {
    
    var pageWrapperController = PageWrapperController()
    
    lazy var pageBar: PageTabBar = {
        let bar = PageTabBar.init(config: .shareCodeWrapper)
        bar.frame = CGRect(x: 0, y: 0, width: 190, height: 40)
        bar.delegate = self
        bar.reloadData()
        return bar
    }()
    
    var selectIndex = 0 {
        didSet {
            pageWrapperController.selectIndex = selectIndex
            pageBar.select(index: self.selectIndex, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationLeft()
        makePageController()
        navigation.item.titleView = pageBar
    }
}

extension ShareCodeWrapper: PageTabBarDelegate {
    
    public func numberOfItem(in tabBar: PageTabBar) -> Int {
        2
    }
    
    public func pageTabBar(_ tabBar: PageTabBar, itemInfoAt index: Int) -> PageTabBarItem.Info {
        if index == 0 {
            return PageTabBarItem.Info(title: "分享码", urlImage: nil)
        } else {
            return PageTabBarItem.Info(title: "用户管理", urlImage: nil)
        }
    }
    
    public func pageTabBar(_ tabBar: PageTabBar, shouleSelectedIndex index: Int) -> Bool {
        true
    }
    
    public func pageTabBar(_ tabBar: PageTabBar, didSelectIndexAt index: Int) {
        self.selectIndex = index
    }
}

extension ShareCodeWrapper: PageWrapperControllerDelegate {
    
    func heightForRow() -> CGFloat {
        UIScreen.bind.height
    }
    
    func selectIndexChaged(_ index: Int) {
        pageBar.select(index: index, animated: true)
    }
    
    func makePageController() {
        
        let sharedCodeConfiguration = AppWebPathConfiguration.shared.webPath(.sharedCode)
        let sharedCode = BaseWebViewController(webURL: sharedCodeConfiguration.webURL, navigationTitle: sharedCodeConfiguration.navigationTitle)
        sharedCode.hasWrapper = true
        
        let userManagerConfiguration = AppWebPathConfiguration.shared.webPath(.userMange)
        let userManager = BaseWebViewController(webURL: userManagerConfiguration.webURL, navigationTitle: userManagerConfiguration.navigationTitle)
        userManager.hasWrapper = true
        
        let controllers = [sharedCode,userManager]
        
        let pageController = PageWrapperController(controllers: controllers,
                                                   main: self,
                                                   selectIndex: self.selectIndex)
        pageController.delegate = self
        pageController.fixedSegement = true
        pageController.hasSegement = false
        pageController.canLoad = true
        addChild(pageController)
        pageController.view.removeFromSuperview()
        pageController.view.backgroundColor = UIColor("#F2F3F3")
        self.view.addSubview(pageController.view)
        pageController.view.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        self.pageWrapperController = pageController
    }
}
