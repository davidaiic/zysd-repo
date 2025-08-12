//
//  ChianedView.swift
//  ChainKit
//
//  Created by wangteng on 2022/8/22.
//

import UIKit

public extension Bind where T: UIView {
    
    var bottomSafeHeight: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 34 }
        guard let window = windowScene.windows.first else { return 34 }
        return window.safeAreaInsets.bottom
    }
    
    var right: CGFloat { self.base.frame.origin.x + self.base.bounds.width  }
    
    var bottom: CGFloat { self.base.frame.origin.y + self.base.bounds.height }
    
    
    /// Width of view.
    public var width: CGFloat {
        get {
            return self.base.frame.size.width
        }
        set {
            self.base.frame.size.width = newValue
        }
    }
    
    //  Height of view.
    public var height: CGFloat {
        get {
            return self.base.frame.size.height
        }
        set {
            self.base.frame.size.height = newValue
        }
    }
    
    /// x origin of view.
    public var x: CGFloat {
        get {
            return self.base.frame.origin.x
        }
        set {
            self.base.frame.origin.x = newValue
        }
    }
    
    ///  y origin of view.
    public var y: CGFloat {
        get {
            return self.base.frame.origin.y
        }
        set {
            self.base.frame.origin.y = newValue
        }
    }
    
    /// The frame rectangle, which describes the view’s location and
    /// size in its superview’s coordinate system.
    @discardableResult
    func frame(_ frame: KeViewKeys.FrameFamily) -> Self {
        switch frame {
        case let .origin(x, y):
            self.base.frame = .init(origin: CGPoint.init(x: x, y: y),
                                         size: self.base.frame.size)
        case .left(let left):
            self.base.frame = .init(origin: CGPoint(x: left, y: self.base.frame.origin.y),
                                         size: self.base.frame.size)
        case .top(let top):
            self.base.frame = .init(origin: CGPoint(x: self.base.frame.origin.x, y: top),
                               size: self.base.frame.size)
        case .width(let width):
            self.base.frame = .init(origin: self.base.frame.origin,
                               size:
                 .init( width: width, height: self.base.frame.size.height))
        case .height(let height):
            self.base.frame = CGRect(x: self.base.frame.origin.x,
                                          y: self.base.frame.origin.y,
                                          width: self.base.frame.size.width,
                                height: height)
        case let .size(width, height):
            self.base.frame = .init(origin: self.base.frame.origin, size: .init(width: width, height: height))
        case .frame(let rect):
            self.base.frame = rect
        }
        self.updateLayers()
        return self
    }
    
    /// Adds a view to the end of the receiver’s list of subviews.
    @discardableResult
    func addSubview(_ view: UIView) -> Self {
        base.addSubview(view)
        return self
    }
    
    /// Adds a view to the begin of the receiver’s list of subviews.
    @discardableResult
    func addSuperview(_ view: UIView) -> Self {
        view.addSubview(self.base)
        return self
    }
    
    /// Appends the layer to the layer’s list of sublayers.
    @discardableResult
    func addSubLayer(_ layer: CALayer) -> Self {
        base.layer.addSublayer(layer)
        return self
    }
    
    /// A Boolean indicating whether sublayers are clipped to the layer’s bounds. Animatable.
    @discardableResult
    func clipped(_ activity: Bool = true) -> Self {
        base.layer.masksToBounds = activity
        return self
    }
    
    /// The radius to use when drawing rounded corners for the layer’s background. Animatable.
    @discardableResult
    func cornerRadius(_ radius: CGFloat, clipped: Bool = true) -> Self {
        base.layer.cornerRadius = radius
        base.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        base.layer.masksToBounds = clipped
        return self
    }
    
    /// The view’s background color
    @discardableResult
    func backgroundColor(_ color: UIColor) -> Self {
        self.base.backgroundColor = color
        return self
    }
    
    /// Adds an action to perform when this view recognizes a tap gesture.
    ///
    /// Use this method to perform a specific `action` when the user clicks or
    /// taps on the view or container `count` times.
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - action: The action to perform.
    @discardableResult
    func onTap(count: Int = 1, perform action: @escaping (T) -> Void) -> Self {
        let targetAction = TargetAction.init(view: self.base) { view in
            action(view as! T)
        }
        self.base.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: targetAction, action:#selector(targetAction.trigger))
        tap.numberOfTapsRequired = count
        self.base.addGestureRecognizer(tap)
        self.base.targetAction = targetAction
        return self
    }
    
    /// The property of layer.mask
    /// - Parameters:
    ///   - radius: CGFloat
    ///   - byRoundingCorners: UIRectCorner
    /// - Returns: The invoker instance object
    @discardableResult
    func cornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask, clipped: Bool = true) -> Self {
        self.base.layer.cornerRadius = radius
        self.base.layer.maskedCorners = maskedCorners
        base.layer.masksToBounds = clipped
        return self
    }
    
    /// The property of layer.mask
    /// - Parameters:
    ///   - radius: CGFloat
    ///   - byRoundingCorners: UIRectCorner
    /// - Returns: The invoker instance object
    @discardableResult
    func gradient(_ colors: [UIColor], direction: KeViewKeys.GradientLayer.Direction = .horizontal) -> Self {
        let gradientLayer = KeViewKeys.GradientLayer.init(colors: colors, direction: direction)
        self.base.gradientLayer = gradientLayer
        self.updateGradientLayer()
        return self
    }
    
    /// The layer’s border. Animatable
    /// - Parameter shape: ViewChainbleEnum.BorderShape
    /// - Returns: The invoke instance object
    @discardableResult
    func border(_ shape: KeViewKeys.BorderStyle) -> Self {
        switch shape {
        case .normal(let color, let width):
            self.base.layer.borderColor = color.cgColor
            self.base.layer.borderWidth = width
        case let .lineDash(strokeColor, fillColor, lineWidth, cornerRadii, lineDashPattern):
            let lineDashLayer = KeViewKeys.LineDashLayer(strokeColor: strokeColor,
                                         fillColor: fillColor,
                                         name: "CAShapeLayerLineDash",
                                         lineWidth: lineWidth,
                                         lineDashPattern: lineDashPattern,
                                         cornerRadii: cornerRadii)
            self.base.lineDashLayer = lineDashLayer
            self.updateLineDashLayer()
        }
        return self
    }
    
    @discardableResult
    func animation(_ animation: KeViewKeys.Animation, completion: ((Bool) -> Void)? = nil) -> Self {
        switch animation {
        case let .fadeIn(duration):
            if self.base.isHidden {
                self.base.isHidden = false
            }
            UIView.animate(withDuration: duration, animations: {
                self.base.alpha = 1
            }, completion: completion)
        case let .fadeOut(duration):
            if self.base.isHidden {
                self.base.isHidden = false
            }
            UIView.animate(withDuration: duration, animations: {
                self.base.alpha = 0
            }, completion: completion)
        }
        return self
    }
    
    /// Take screenshot of view (if applicable).
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.base.layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    /// Take screenshot of view (if applicable).
    func screenshot(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.base.layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.base.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    
    /// Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    @discardableResult
    func shadow(color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0),
                radius: CGFloat = 3,
                offset: CGSize = .zero,
                opacity: Float = 0.5) -> Self {
        self.base.layer.shadowColor = color.cgColor
        self.base.layer.shadowOffset = offset
        self.base.layer.shadowRadius = radius
        self.base.layer.shadowOpacity = opacity
        
        self.base.setNeedsLayout()
        self.base.layoutIfNeeded()
        self.base.layer.shadowPath = UIBezierPath(rect: self.base.bounds).cgPath
        
        return self
    }
    
    @discardableResult
    func updateLayers() -> Self {
        updateGradientLayer()
        updateLineDashLayer()
        return self
    }
    
    @discardableResult
    func updateGradientLayer() -> Self {
        guard var gradientLayer = self.base.gradientLayer else {
            return self
        }
        self.base.layoutIfNeeded()
        self.base.setNeedsLayout()
        
        if self.base.bounds != .zero {
            gradientLayer.roundedRect = self.base.bounds
            deleteLayer(from: gradientLayer.name)
            self.base.layer.insertSublayer(gradientLayer.makeLayer(), at: 0)
        }
        return self
    }

    @discardableResult
    func updateLineDashLayer() -> Self {
        guard var lineDashLayer = self.base.lineDashLayer else {
            return self
        }
        self.base.layoutIfNeeded()
        self.base.setNeedsLayout()
        lineDashLayer.pathBounds = self.base.bounds
        deleteLayer(from: lineDashLayer.name)
        self.base.layer.addSublayer(lineDashLayer.makeLayer())
        return self
    }
    
    @discardableResult
    func deleteLayer(from name: String?) -> Self {
        guard let name = name, !name.isEmpty
        else {
            return self
        }
        self.base.layer.sublayers?
            .filter({ $0.name == name})
            .first?
            .removeFromSuperlayer()
        return self
    }
    
    /// Get view's parent view controller
    var parentViewController: UIViewController? {
        weak var parentResponder: UIResponder? = self.base
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var viewController: UIViewController? {
        var view = base.superview
        while view != nil {
            if let viewController = view?.next as? UIViewController {
                return viewController
            }
            view = view?.superview
        }
        return nil
    }
}

@objcMembers
public class TargetAction: NSObject {
 
    var handler: ((UIView)->())
    
    weak var view: UIView?
    
    init(view: UIView, handler: @escaping (UIView)->()) {
        self.view = view
        self.handler = handler
        super.init()
    }
    
    @objc func trigger() {
        if let view = view {
            handler(view)
        }
    }
}

extension UIView {
    
    private struct AssociatedObjectKey {
        static var kLineDashLayer = "kLineDashLayer"
        static var kGradientLayer = "kGradientLayer"
        static var kTargetAction = "kTargetEventActionKey"
    }
    
    var targetAction: TargetAction? {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectKey.kTargetAction) as? TargetAction
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectKey.kTargetAction, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var lineDashLayer: KeViewKeys.LineDashLayer? {
        get {
            objc_getAssociatedObject(self, &AssociatedObjectKey.kLineDashLayer) as? KeViewKeys.LineDashLayer
        } set {
            objc_setAssociatedObject(self, &AssociatedObjectKey.kLineDashLayer, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var gradientLayer: KeViewKeys.GradientLayer? {
        get {
            objc_getAssociatedObject(self, &AssociatedObjectKey.kGradientLayer) as? KeViewKeys.GradientLayer
        } set {
            objc_setAssociatedObject(self, &AssociatedObjectKey.kGradientLayer, newValue,
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public struct KeViewKeys {
    
    public enum FrameFamily {
        case left(CGFloat)
        case top(CGFloat)
        case width(CGFloat)
        case height(CGFloat)
        case origin(x: CGFloat, y: CGFloat)
        case size(width: CGFloat, height: CGFloat)
        case frame(CGRect)
    }
    
    public enum BorderStyle {
        case normal(color: UIColor, width: CGFloat = 0.5)
        case lineDash(strokeColor: UIColor,
                      fillColor: UIColor = .clear,
                      lineWidth: CGFloat = 0.5,
                      cornerRadii: CGFloat,
                      lineDashPattern: [NSNumber] = [NSNumber(4.0), NSNumber(3.0)])
    }
    
    public struct LineDashLayer {
        
        var strokeColor: UIColor?
        var fillColor: UIColor?
        var name = ""
        var lineWidth: CGFloat = 0
        var lineDashPattern: [NSNumber] = []
        var pathBounds: CGRect = .zero
        var cornerRadii: CGFloat = 0
        
        public func makeLayer() -> CAShapeLayer {
            let path = UIBezierPath(roundedRect: self.pathBounds,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: cornerRadii, height: cornerRadii))
            let shapeLayer = CAShapeLayer()
            shapeLayer.name = "CAShapeLayerLineDash"
            shapeLayer.strokeColor = strokeColor?.cgColor
            shapeLayer.fillColor = fillColor?.cgColor
            shapeLayer.lineWidth = lineWidth
            shapeLayer.path = path.cgPath
            shapeLayer.lineDashPattern = lineDashPattern
            return shapeLayer
        }
    }
    
    public struct GradientLayer {
        
        public enum Direction {
        case horizontal
        case vertical
        }
        
        var colors: [UIColor] = []
        var direction: Direction = .horizontal
        var roundedRect: CGRect = .zero
        var name = "GradientLayer"
        
        public func makeLayer() -> CAGradientLayer {
            let gradientLayer = CAGradientLayer()
            gradientLayer.name = name
            gradientLayer.frame = self.roundedRect
            gradientLayer.colors = colors.map { $0.cgColor }
            switch direction {
            case .horizontal:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            case .vertical:
                break
            }
            return gradientLayer
        }
    }
    
    public enum Animation {
        case fadeIn(duration: TimeInterval)
        case fadeOut(duration: TimeInterval)
    }
}
