//
//  Bind.swift
//  ChainKit
//
//  Created by wangteng on 2022/8/22.
//

import UIKit

public struct Bind<T> {
    /// Base object to extend.
    public var base: T
    /// Creates extensions with base object.
    ///
    /// - parameter base: Base object.
    public init(_ base: T) {
        self.base = base
    }
}

/// A type that has reactive extensions.
public protocol Bindble {
    associatedtype T
    static var bind: Bind<T>.Type { get set }
    var bind: Bind<T> { get set }
}

extension Bindble {
   
    public static var bind: Bind<Self>.Type {
        get { Bind<Self>.self }
        set { _ = newValue }
    }

    public var bind: Bind<Self> {
        get { Bind(self) }
        set { _ = newValue }
    }
}

extension UIView: Bindble { }
extension UIImage: Bindble { }

public protocol BindCompatible {
    associatedtype T
}

public extension BindCompatible {
    static var bind: BindGeneric<Self, T>.Type {
        get { return BindGeneric<Self, T>.self }
        set { }
    }
    var bind: BindGeneric<Self, T> {
        get { return BindGeneric(self) }
        set { }
    }
}

public struct BindGeneric<Base, T> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}
