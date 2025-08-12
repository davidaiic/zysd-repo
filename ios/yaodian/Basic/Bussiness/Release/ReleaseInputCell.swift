//
//  ReleaseInputCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/13.
//

import UIKit

class ReleaseInputCell: UITableViewCell, Reusable {
    
    var model = ReleaseModel() {
        didSet {
            textView.text = model.text
        }
    }
    
    lazy var textView: BindTextView = {
        let textView = BindTextView()
        textView.placeholderColor = UIColor(0xCBCDD0)
        textView.layer.cornerRadius = 6
        textView.growingDelegate = self
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = UIColor(0x444444)
        textView.placeholder = "写些什么和大家分享…"
        textView.contentInset = .zero
        textView.backgroundColor = .clear
        textView.tintColor = .barTintColor
        textView.maxLength = 1000
        textView.textContainer.lineFragmentPadding = 0
        textView.minHeight = 160
        return textView
    }()
    
    var textViewDidChangeHeightHandler: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        contentView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.left.top.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
            make.height.equalTo(160)
        }
    }
}

extension ReleaseInputCell: BindTextViewDelegate {
    
    func textDidChange(_ textView: BindTextView) {
        model.text = textView.text
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {}
    func textViewDidChangeHeight(_ textView: BindTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            textView.snp.remakeConstraints { make in
                make.left.top.equalTo(15)
                make.right.equalTo(-15)
                make.bottom.equalTo(-15)
                make.height.equalTo(height)
            }
        }
        textViewDidChangeHeightHandler?()
    }
    func textBeyondMaxCount(_ textView: BindTextView) {}
    func textViewLineChange(_ textView: BindTextView, lineNumbers: Int) {}
}

extension ReleaseInputCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
}

