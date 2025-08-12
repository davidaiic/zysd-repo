
import UIKit

/// The window used to display the PKHUD within. Placed atop the applications main window.
public class HudContainerView: UIView {

    public let frameView: FrameView
    
    public var frameCenteryOffset: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    internal init(frameView: FrameView = FrameView()) {
        self.frameView = frameView
        super.init(frame: CGRect.zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        frameView = FrameView()
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
        isHidden = true

        addSubview(backgroundView)
        addSubview(frameView)
    }
 
    public override func layoutSubviews() {
        super.layoutSubviews()
        frameView.center = CGPoint(x: center.x, y: center.y+frameCenteryOffset)
        backgroundView.frame = bounds
    }

    internal func showFrameView() {
        layer.removeAllAnimations()
        frameView.center = center
        frameView.alpha = 1.0
        isHidden = false
    }

    fileprivate var willHide = false

    internal func hideFrameView(animated anim: Bool, completion: ((Bool) -> Void)? = nil) {
        let finalize: (_ finished: Bool) -> Void = { finished in
            self.isHidden = true
            self.removeFromSuperview()
            self.willHide = false

            completion?(finished)
        }

        if isHidden {
            return
        }

        willHide = true

        if anim {
            UIView.animate(withDuration: 0.3, animations: {
                self.frameView.alpha = 0.0
                self.hideBackground(animated: false)
            }, completion: { _ in finalize(true) })
        } else {
            self.frameView.alpha = 0.0
            finalize(true)
        }
    }

    fileprivate let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white:0.0, alpha:0.25)
        view.alpha = 0.0
        return view
    }()

    internal func showBackground(animated anim: Bool) {
        if anim {
            UIView.animate(withDuration: 0.175, animations: {
                self.backgroundView.alpha = 1.0
            })
        } else {
            backgroundView.alpha = 1.0
        }
    }

    internal func hideBackground(animated anim: Bool) {
        if anim {
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView.alpha = 0.0
            })
        } else {
            backgroundView.alpha = 0.0
        }
    }
}
