//
//  TabBarController.swift
//  Drug
//
//  Created by wangteng on 2023/2/10.
//

import UIKit
import Bind
import EachNavigationBar

class EntryTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
        configureTabBar()
        addChildren()

    }
    
    private func configureTabBar() {
        
        setValue(EntryTabBar(), forKeyPath: "tabBar")
        if let tabBar = tabBar as? EntryTabBar {
            tabBar.setUp()
        }
    }
    
    private func addChildren() {
        addChild(EntryViewController(),
                 imageNamed: "tab_home",
                 selectedImageNamed: "tab_home_activity",
                 title: "首页")
        
        addChild(CircleWrapperController(),
                 imageNamed: "tab_hoop",
                 selectedImageNamed: "tab_hoop_activity",
                 title: "圈子")
        addChild(ProfileViewController(),
                 imageNamed: "tab_mine",
                 selectedImageNamed: "tab_mine_activity",
                 title: "我的")
    }
    
    private func addChild(_ viewController: UIViewController,
                          imageNamed: String,
                          selectedImageNamed: String,
                          title: String) {
        let navigation = UINavigationController(rootViewController: viewController)
        
        // config
        navigation.navigation.configuration.isEnabled = true
        
        navigation.navigation.configuration.isTranslucent = false
        navigation.navigation.configuration.barTintColor = UIColor(named: "barTintColor")
        navigation.navigation.configuration.tintColor = UIColor.white
        navigation.navigation.configuration.isShadowHidden = true
        navigation.navigation.configuration.statusBarStyle = .lightContent
        navigation.navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        viewController.tabBarItem.image = UIImage(named: imageNamed)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageNamed)?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
        viewController.tabBarItem.titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -4)
        viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
        let normalTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init( "#C0C0C0"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium),
        ]
        let selectedTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.init("#5CC5AD"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium),
        ]
        
        viewController.tabBarItem.setTitleTextAttributes(normalTitleTextAttributes, for: .normal)
        viewController.tabBarItem.setTitleTextAttributes(selectedTitleTextAttributes, for: .selected)
       
        self.addChild(navigation)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension EntryTabController: UITabBarControllerDelegate {
    
}
