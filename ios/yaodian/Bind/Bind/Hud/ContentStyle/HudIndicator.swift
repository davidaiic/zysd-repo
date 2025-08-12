
import UIKit

class HudIndicator: UIView {
    
    let indicatorView = UIActivityIndicatorView()
    
    static let defaultSquareBaseViewFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: 50, height: 50))
    
    override init(frame: CGRect = .zero) {
        super.init(frame: HudIndicator.defaultSquareBaseViewFrame)
        initView()
    }
    
    private func initView() {
        indicatorView.hidesWhenStopped = true
        indicatorView.startAnimating()
        layer.cornerRadius = 4
        layer.masksToBounds = true
        indicatorView.style = .white
        let viewWidth = bounds.size.width
        let viewHeight = bounds.size.height
        let halfWidth = CGFloat(ceilf(CFloat(viewWidth / 2.0)))
        let halfHeight = CGFloat(ceilf(CFloat(viewHeight / 2.0)))
        indicatorView.frame = CGRect(origin: CGPoint(x:halfWidth-10, y:halfHeight-10), size: CGSize(width: 20, height: 20))
        backgroundColor = UIColor(red: 41/255.0, green: 42/255.0, blue: 48/255.0, alpha: 1)
        addSubview(indicatorView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HudIndicator: HudAnimating {
    func startAnimation() {
        indicatorView.startAnimating()
    }
    
    func stopAnimation() {
        indicatorView.stopAnimating()
    }
}

