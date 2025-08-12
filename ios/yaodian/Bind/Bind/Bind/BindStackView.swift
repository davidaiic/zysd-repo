//
//  KeStackView.swift
//  Drug
//
//  Created by wangteng on 2023/2/9.
//

import UIKit

public extension Bind where T: UIStackView {
    
    /// 指定顺序添加 `arrangedSubview`
    /// - Parameters:
    ///   - view: `arrangedSubview`
    ///   - stackIndex: 在 `UIStackView` 中显示的位置
    func insertArrangedSubview(_ view: UIView, position stackIndex: Int) {
        view.stackIndex = stackIndex
        var insertPosition = self.base.arrangedSubviews.count
        for (posi, arrangedSubview) in self.base.arrangedSubviews.enumerated() where arrangedSubview.stackIndex >= view.stackIndex {
            insertPosition = posi
            break
        }
        self.base.insertArrangedSubview(view, at: insertPosition)
    }

    /// 由于 `removeArrangedSubview` 只删除布局控制 此方法删布局并且 `removeFromSuperview`
    /// - Parameter view: remove arrangedSubview
    func deleteArrangedSubview(_ view: UIView) {
        self.base.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    /// 根据 `stackIndex` 删除对应的 `arrangedSubview` 配合 `insertSortArrangedSubview(_: at:)` 使用
    /// - Parameter stackIndex: remove stackIndex
    func deleteArrangedSubview(position stackIndex: Int) {
        guard let view = self.base.arrangedSubviews.first(where: { $0.stackIndex == stackIndex }) else {
            return
        }
        deleteArrangedSubview(view)
    }
   
    /// 移除所有的 arrangedSubview 布局和显示
    func removeAllArrangedSubview() {
        self.base.arrangedSubviews.forEach { deleteArrangedSubview($0) }
    }
}

private var kStackIndex = "kStackIndex"

extension UIView {
    
    /// 在 `insertSortArrangedSubview(_: at:)` 使用 用来排序 `arrangedSubview`
    public var stackIndex: Int {
        get {
            if let aValue = objc_getAssociatedObject(self, &kStackIndex) as? Int {
                return aValue
            } else {
               return 0
            }
        }
        set {
            objc_setAssociatedObject(self, &kStackIndex, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
