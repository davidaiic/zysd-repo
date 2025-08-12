//
//  PageWrapperViewController.swift
//  Drug
//
//  Created by wangteng on 2023/3/1.
//

import UIKit

class PageWrapperViewController: UIViewController {

    var pageWrapperController = PageWrapperController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makePageController()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PageWrapperViewController: PageWrapperControllerDelegate {
    
    func heightForRow() -> CGFloat {
        UIScreen.bind.height-UIScreen.bind.navigationBarHeight-UIScreen.bind.safeBottomInset-50
    }
    
    func makePageController() {
        let controllers = ["全部", "待付款", "待发货", "待收货","已取消"].map { title -> PageCViewController in
            let viewController = PageCViewController()
            viewController.title = title
            return viewController
        }
        
        let pageController = PageWrapperController(controllers: controllers,
                                                   main: self,
                                                   selectIndex: 2)
        pageController.delegate = self
        pageController.fixedSegement = true
        pageController.canLoad = true
        pageController.view.removeFromSuperview()
        pageController.view.backgroundColor = UIColor("#F2F3F3")
        self.view.addSubview(pageController.view)
        pageController.view.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.bottom.right.left.equalTo(0)
        }
        self.pageWrapperController = pageController
    }
  
}
