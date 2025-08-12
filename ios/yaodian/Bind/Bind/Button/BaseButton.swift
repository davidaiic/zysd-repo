//
//  KeButton.swift
//  Drug
//
//  Created by wangteng on 2023/2/11.
//

import Foundation

public class BaseButton: UIControl {
    
    public enum Bind {
        case axis(NSLayoutConstraint.Axis)
        case spacing(CGFloat)
        case contentEdgeInsets(UIEdgeInsets)
        case title(String)
        case font(UIFont)
        case color(UIColor)
        case image(UIImage?)
        case backgroundColor(UIColor)
        case cornerRadius(CGFloat)
    }
    
    @discardableResult
    public func bind(_ bind: Bind) -> BaseButton {
        switch bind {
        case .axis(let axis):
            stackView.axis = axis
        case .spacing(let spacing):
            stackView.spacing = spacing
        case .contentEdgeInsets(let value):
            guard stackView.superview != nil else {
                return self
            }
            stackView.snp.remakeConstraints { make in
                make.edges.equalTo(value)
            }
        case .title(let title):
            titleLabel.text = title
            stackView.addArrangedSubview(titleLabel)
        case .font(let font):
            self.titleLabel.font = font
        case .color(let color):
            self.titleLabel.textColor = color
        case .image(let image):
            imageView.image = image
            stackView.addArrangedSubview(imageView)
        case .backgroundColor(let color):
            self.backgroundColor = color
        case .cornerRadius(let radius):
            self.layer.cornerRadius = radius
            self.layer.masksToBounds =  true
        }
        return self
    }

    public lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.distribution = .fillProportionally
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        addComponts()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addComponts() {
        addSubview(stackView)
        stackView.snp.remakeConstraints { make in
            make.edges.equalTo(0)
        }
    }
    
    /// Make GCD TimerSource
    /// - Parameter time: time description
    /// - Parameter deadline: deadline description
    /// - Parameter repeating: repeating description
    /// - Parameter eventHandler: eventHandler description
    /// - Parameter eventHandlerDispatchQueue: eventHandlerDispatchQueue description
    /// - Parameter stop: stop description
    public func countDown(time: Int,
                   deadline: DispatchTime = .now(),
                   repeating: DispatchTimeInterval = .seconds(1),
                   eventHandler: @escaping ((Int)->Void),
                   eventHandlerDispatchQueue: DispatchQueue = .main,
                   stop: @escaping ((Int)->Bool)) {
        self.isUserInteractionEnabled = false
        DispatchQueue.bind.countDown(time: time,
                                   deadline: deadline,
                                   repeating: repeating,
                                   eventHandler: eventHandler,
                                   eventHandlerDispatchQueue: eventHandlerDispatchQueue)
        { (value) -> Bool in
            let stop = stop(value)
            if stop {
                DispatchQueue.main.async {
                    self.isUserInteractionEnabled = true
                }
            }
            return stop
        }
    }
    
    public func rotateImage() {
        UIView.animate(withDuration: 0.5, animations: {[weak self] () -> () in
            if let selfie = self {
                selfie.imageView.transform = selfie.imageView.transform.rotated(by: 180 * CGFloat(Double.pi/180))
            }
        })
    }
}
