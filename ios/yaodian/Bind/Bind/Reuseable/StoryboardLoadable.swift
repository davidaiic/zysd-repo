//
//  ReUseable.swift
//  MotorFansKit
//
//  Created by wangteng on 2021/8/13.
//

import UIKit

public protocol StoryboardLoadable: AnyObject {
    
    /// The UIStoryboard to use when we want to instantiate this ViewController
    static var sceneStoryboard: UIStoryboard { get }
    
    /// The scene identifier to use when we want to instantiate this ViewController from its associated Storyboard
    static var sceneIdentifier: String { get }
}

// MARK: Default Implementation
public extension StoryboardLoadable {
    
    /// By default, use the storybaord with the same name as the class
    static var sceneStoryboard: UIStoryboard {
        return UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
    }
    
    /// By default, use the `sceneIdentifier` with the same name as the class
    static var sceneIdentifier: String {
        return String(describing: self)
    }
}

public extension StoryboardLoadable where Self: UIViewController {
    
    /**
     Create an instance of the ViewController from its associated Storyboard and the
     Scene with identifier `sceneIdentifier`
     - returns: instance of the conforming ViewController
     */
    static func initFromSb() -> Self {
        let storyboard = Self.sceneStoryboard
        let viewController = storyboard.instantiateViewController(withIdentifier: self.sceneIdentifier)
        guard let typedViewController = viewController as? Self else {
            fatalError("The viewController '\(self.sceneIdentifier)' of '\(storyboard)' is not of class '\(self)'")
        }
        return typedViewController
    }
}
