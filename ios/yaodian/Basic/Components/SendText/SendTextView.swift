//
//  ToCommentView.swift
//  Basic
//
//  Created by wangteng on 2023/3/17.
//

import Foundation

class SendTextView: UIView {
    
    var maxImages = 6 {
        didSet {
            configuration.maxImages = maxImages
        }
    }
    
    var height: CGFloat = 220
    
    var doneBtnClickedHandler: ((String, [AppendImageModel]) -> Void)?
    
    lazy var textView: BindTextView = {
        let textView = BindTextView()
        textView.placeholderColor = UIColor(0xCBCDD0)
        textView.layer.cornerRadius = 6
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.placeholder = "写下您的评论～"
        textView.placeholderColor = UIColor(0x999999)
        textView.backgroundColor = .clear
        textView.returnKeyType = .send
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor(0xE0E0E0).cgColor
        textView.minHeight = 80
        textView.contentInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        textView.tintColor = .barTintColor
        textView.growingDelegate = self
        textView.delegate = self
        textView.textContainer.lineFragmentPadding = 0
        textView.textColor = UIColor(0x333333)
        return textView
    }()
    
    lazy var privacyBt: BaseButton = {
        let baseBt = BaseButton()
            .bind(.title("查看《评论规范公约》"))
            .bind(.font(.systemFont(ofSize: 12, weight: .semibold)))
            .bind(.color(UIColor(0x0FC8AC)))
        return baseBt
    }()
    
    lazy var privacyText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(0x666666)
        label.numberOfLines = 0
        label.text = "重要提示：网友、医生言论仅代表其个人观点，不代表本站同意其说法，请谨慎发帖参阅，本站不承担由此引起的法律责任。"
        return label
    }()
    
    lazy var configuration: AddPictureConfiguration = {
        let configuration = AddPictureConfiguration()
        configuration.maxWidth = UIScreen.bind.width-30
        configuration.maxImages = self.maxImages
        configuration.canBroswer = false
        configuration.row = 6
        return configuration
    }()
    
    lazy var imagesView: AddPictureView = {
        let view = AddPictureView(configuration: self.configuration)
        return view
    }()
    
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
        
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(80)
        }
        
        addSubview(privacyBt)
        privacyBt.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.bottom.equalTo(0)
            make.height.equalTo(32)
        }
        
        addSubview(privacyText)
        privacyText.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-32)
        }
        
        addSubview(imagesView)
        imagesView.backgroundColor = .clear
        imagesView.snp.remakeConstraints { make in
            make.top.equalTo(textView.snp.bottom).offset(10)
            make.left.equalTo(15)
            make.width.equalTo(configuration.maxWidth)
            make.height.equalTo(configuration.height)
        }
    }
    
    deinit {
        debugPrint("\(self) dealloc")
    }
}

extension SendTextView: BindTextViewDelegate {
    
    func textDidChange(_ textView: BindTextView) {
        
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {}
    func textViewDidChangeHeight(_ textView: BindTextView, height: CGFloat) {
      
    }
    func textBeyondMaxCount(_ textView: BindTextView) {}
    func textViewLineChange(_ textView: BindTextView, lineNumbers: Int) {}
}

extension SendTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            doneBtnClickedHandler?(textView.text, configuration.imagModels)
            return false
        }
        return true
    }
    
}
