//
//  Box.swift
//  Basic
//
//  Created by wangteng on 2023/3/12.
//

import Foundation
import Kingfisher

class BoxViewLayout {
    
    var frames: [CGRect] = []
    
    let spacing: CGFloat = 4.5
    let boxItemSize: CGSize = .init(width: 110, height: 110)
    
    var boxWidth: CGFloat {
        boxItemSize.width+spacing
    }
    
    var boxHeight: CGFloat {
        boxItemSize.height+spacing
    }
    
    var boxWrapperSize: CGSize {
        var prefix = 3
        if frames.count == 4 {
            prefix = 2
        }
        guard let last = frames.last,
                let rowLast = frames.prefix(prefix).last
        else { return .zero }
        
        let w = rowLast.origin.x+rowLast.width
        let h = last.origin.y+last.height
        return CGSize(width: w, height: h)
    }
    
    var imageURLs: [String] = [] {
        didSet {
            layout()
        }
    }
    
    func layout() {
        
        switch imageURLs.count {
        case 1:
            frames.append(.init(x:0, y: 0, width: 160, height: 120))
        case 4:
            frames.append(.init(origin: .zero, size: boxItemSize))
            frames.append(.init(origin: .init(x: boxWidth, y: 0), size: boxItemSize))
            frames.append(.init(origin: .init(x: 0, y: boxHeight), size: boxItemSize))
            frames.append(.init(origin: .init(x: boxWidth, y: boxHeight), size: boxItemSize))
        default:
            for index in 0..<imageURLs.count {
                let col: CGFloat = CGFloat(index%3)
                let row: CGFloat = CGFloat(index/3)
                frames.append(.init(origin: .init(x: col*boxWidth, y: row*boxHeight), size: boxItemSize))
            }
        }
    }
}

protocol BoxViewDelegate: AnyObject {
    func didTaped(_ boxView: BoxView, index: Int, imageView: UIImageView)
}

class BoxView: UIView {
    
    weak var delegate: BoxViewDelegate?
    
    var boxLayout = BoxViewLayout() {
        didSet {
            layout()
        }
    }
    
    var boxes: [AnimatedImageView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        for index in 0...8 {
            let box = AnimatedImageView()
            box.contentMode = .scaleAspectFill
            box.clipsToBounds = true
            box.isHidden = true
            box.tag = index
            box.backgroundColor = UIColor(0xF9F9F9)
            addSubview(box)
            box.bind.onTap { [weak self] imageView in
                guard let self = self else { return }
                self.delegate?.didTaped(self, index: index, imageView: imageView)
            }
            boxes.append(box)
        }
    }
    
    private func layout() {
        boxes.forEach{ $0.isHidden = true}
        for (index, frame) in boxLayout.frames.enumerated() {
            boxes[index].isHidden = false
            boxes[index].frame = frame
            let imageURL = boxLayout.imageURLs[index]
            if imageURL.bind.isValidUrl {
                boxes[index].kf.setImage(with: imageURL.bind.url,
                                         placeholder: "place_holder".bind.image,
                                         options: [.scaleFactor(UIScreen.main.scale),
                                            .transition(.fade(0.25))])
            } else {
                boxes[index].image = nil
            }
        }
    }
}
