//
//  ButtonHelper.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation

extension UIButton {
    
    static func makeCommon(_ title: String) -> UIButton {
        let bt = UIButton()
        bt.setBackgroundImage("bt_enable".bind.image, for: .normal)
        bt.setBackgroundImage("bt_diable".bind.image, for: .selected)
        bt.setTitle(title, for: .normal)
        bt.setTitleColor(.white, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        bt.layer.cornerRadius = 22
        bt.layer.masksToBounds = true
        return bt
    }
}

class DragButton: UIButton {

    private var startPoint = CGPoint(x: 0, y: 0)
    
    var anchorView = UIWindow.currentWindow!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func pan(_ ges: UIPanGestureRecognizer) {
        
        let translation =  ges.translation(in: self)
        
        if ges.state == .began {
            self.startPoint = self.center
        }
       
        var x = self.startPoint.x+translation.x
        
        if x < self.frame.width*0.5 {
            x = self.frame.width*0.5
        } else if x + self.frame.width*0.5 > anchorView.bounds.width {
            x = anchorView.bounds.width - self.frame.width*0.5
        }
        
        var y = self.startPoint.y+translation.y
        if y  < UIScreen.bind.navigationBarHeight+44 + self.frame.height*0.5 {
            y = UIScreen.bind.navigationBarHeight+44 + self.frame.height*0.5
        } else if y > UIScreen.bind.height - UIScreen.bind.navigationBarHeight - UIScreen.bind.safeBottomInset {
            y = UIScreen.bind.height - UIScreen.bind.navigationBarHeight - UIScreen.bind.safeBottomInset
        }
        self.center = CGPoint(x: x, y: y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}

