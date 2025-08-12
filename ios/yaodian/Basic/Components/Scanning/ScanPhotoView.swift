//
//  ScanPhotoView.swift
//  Basic
//
//  Created by wangteng on 2023/3/4.
//

import UIKit
import Bind

class ScanPhotoView: UIView, Popupable {

    lazy var photo: UIImageView = {
        let photo = UIImageView()
        photo.contentMode = .scaleAspectFit
        return photo
    }()
    
    private lazy var blur: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(0x000000, alpha: 0.4)
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("取消", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addHierarchy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addHierarchy() {
        backgroundColor = .black
        addSubview(photo)
        photo.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        addSubview(blur)
        blur.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        
        addSubview(closeButton)
        closeButton.layer.cornerRadius = 15
        closeButton.layer.borderColor = UIColor.white.cgColor
        closeButton.layer.borderWidth = 1
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.bottom.equalTo(-100)
            make.height.equalTo(30)
        }
    }
    
    var customAnimation: Bool { true }
    
    func beginAnimation(completion: @escaping () -> Void) {
        self.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1
        }, completion: { _ in
            completion()
        })
    }
    
    func endAnimation(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0
        }, completion: { _ in
            completion()
        })
    }
}
