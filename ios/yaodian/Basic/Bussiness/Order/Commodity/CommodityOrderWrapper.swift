//
//  CommodityOrderWrapper.swift
//  Basic
//
//  Created by wangteng on 2023/4/12.
//

import Foundation

class CommodityOrderWrapper: BaseViewController {

    let manager = CommodityOrderManager()
    
    var pageWrapperController = PageWrapperController()
    
    var selectIndex = 0 {
        didSet {
            pageWrapperController.selectIndex = selectIndex
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makePageController()
    }
}

extension CommodityOrderWrapper: PageWrapperControllerDelegate {
    
    func heightForRow() -> CGFloat {
        view.bounds.height
    }
 
    func makePageController() {
        
        let controllers = manager.pageModels.map { page -> CommodityOrderListController in
            let viewController = CommodityOrderListController()
            viewController.title = page.type.rawValue
            viewController.pageModel = page
            return viewController
        }
        
        let pageController = PageWrapperController(controllers: controllers,
                                                   main: self,
                                                   selectIndex: self.selectIndex)
        pageController.delegate = self
        pageController.fixedSegement = true
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

extension CommodityOrderWrapper: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        Hud.hide()
        switch fetch {
        case .onCompleted:
            break
        case .failure:
            break
        }
    }
}
