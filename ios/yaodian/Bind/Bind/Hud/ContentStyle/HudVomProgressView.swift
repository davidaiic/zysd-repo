
import UIKit

internal class HudVomProgressView: UIView {
    let ballWidth:CGFloat = 10
    /// 显示的文本内容
    var showText: String = ""
    /// 显示的文本颜色
    var textColor: UIColor? = nil
    /// 蒙层
    var showBlur: Bool = false
    
    static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 156.0, height: 156.0))

    init(frame: CGRect = .zero,
         message: String = "",
         messageColor: UIColor? = nil,
         blur: Bool = false) {
        super.init(frame: HudVomProgressView.defaultSquareBaseViewFrame)
        showText = message
        textColor = messageColor
        showBlur = blur
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func initView() {
        
        // 当且仅当，需要显示蒙层，并且可以找到当前Window的情况下才会渲染蒙层。
        if showBlur, let window = UIWindow.currentWindow {
            self.frame.size = window.frame.size
            // 蒙层默认颜色
            backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        } else {
            backgroundColor = .clear
        }

        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height
        let halfWidth = CGFloat(ceilf(CFloat(viewWidth / 2.0)))
        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))
        firstView.frame = CGRect(origin: CGPoint(x:halfWidth-16, y:halfHeight), size: CGSize(width: ballWidth, height: ballWidth))
        secondView.frame = CGRect(origin: CGPoint(x:halfWidth+8, y:halfHeight), size: CGSize(width: ballWidth, height: ballWidth))
        
        let textHeight = label.sizeThatFits(CGSize(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        label.frame = CGRect(origin: CGPoint(x: 0, y:firstView.frame.origin.y + firstView.frame.size.height + 20), size: CGSize(width: frame.size.width, height: textHeight))
        
        addSubview(firstView)
        addSubview(secondView)
        if showText.count > 0 {
            addSubview(label)
        }
    }

    private let firstView: UIView = {
        let view = UIView()
        view.alpha = 0.85
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 0/255, green: 190/255, blue: 190/255, alpha: 1)
        return view
    }()

    private let secondView: UIView = {
        let view = UIView()
        view.alpha = 0.85
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 0/255, green: 218/255, blue: 218/255, alpha: 1)
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = showText
        label.textColor = textColor ?? #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height

        let halfWidth = CGFloat(ceilf(CFloat(viewWidth / 2.0)))
        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))

        firstView.frame = CGRect(origin: CGPoint(x:halfWidth-16, y:halfHeight), size: CGSize(width: ballWidth, height:ballWidth))
        secondView.frame = CGRect(origin: CGPoint(x:halfWidth+8, y:halfHeight), size: CGSize(width: ballWidth, height:ballWidth))
    }
}

// Mark: HudAnimating
extension HudVomProgressView: HudAnimating{
    func startAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "position")
        let x = firstView.frame.origin.x
        let y = firstView.frame.origin.y
        let x1 = secondView.frame.origin.x
        let y1 = secondView.frame.origin.y

        animation.values = [
            CGPoint(x:x , y: y),
            CGPoint(x:x1, y: y),
            CGPoint(x:x, y: y)
        ]
        animation.duration = 0.8
        animation.repeatCount = Float(INT_MAX)
        animation.isRemovedOnCompletion = false

        firstView.layer.add(animation, forKey: "crossAnimation")

        let secondAnimation = CAKeyframeAnimation(keyPath: "position")

        secondAnimation.values = [
            CGPoint(x:x1 , y: y1),
            CGPoint(x:x, y: y1),
            CGPoint(x:x1, y: y1)
        ]
        secondAnimation.duration = 0.8
        secondAnimation.repeatCount = Float(INT_MAX)
        secondAnimation.isRemovedOnCompletion = false

        secondView.layer.add(secondAnimation, forKey: "crossAnimation")
    }
    func stopAnimation() {
    }
}
