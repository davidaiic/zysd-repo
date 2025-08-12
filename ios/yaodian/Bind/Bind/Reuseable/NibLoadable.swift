//
//  NibLoadable.swift
//  MotorFansKit
//
//  Created by wangteng on 2021/8/13.
//

import UIKit

// MARK: Protocol Definition

/// Make your UIView subclasses conform to this protocol when:
///  * they *are* NIB-based, and
///  * this class is used as the XIB's root view
///
/// to be able to instantiate them from the NIB in a type-safe manner
public protocol NibLoadable: AnyObject {
    
    /// The nib file to use to load a new instance of the View designed in a XIB
    static var nib: UINib { get }
    
    /// The nibName to use to load a new  instance of the ViewController designed in a XIB
    static var nibName: String { get }
    
}

// MARK: Default implementation
public extension NibLoadable {
    
    /// By default, use the nib which have the same name as the name of the class,
    /// and located in the bundle of that class
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    /// By default, use the nib which have the same name as the name of the class,
    static var nibName: String {
        return String(describing: self)
    }
}

// MARK: Support for instantiation from NIB
public extension NibLoadable where Self: UIView {
    
    /// Returns a `UIView` object instantiated from nib
    /// - Returns: A `NibLoadable`, `UIView` instance
    static func initFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: nil, options: nil).first as? Self else {
            fatalError("The nib \(nib) expected its root view to be of type \(self)")
        }
        return view
    }
}

// MARK: Support for instantiation from NIB
public extension NibLoadable where Self: UIViewController {
    
    /// Returns a `UIViewController` object instantiated from nib
    /// - Returns: A `NibLoadable`, `UIViewController` instance
    static func initFromNib() -> Self {
        let viewController = Self.init(nibName: nibName, bundle: Bundle(for: self))
        return viewController
    }
}
