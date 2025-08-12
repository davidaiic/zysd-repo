//
//  PersonalInformationController.swift
//  Basic
//
//  Created by wangteng on 2023/3/26.
//

import Foundation

class PersonalInformationController: BaseViewController, StoryboardLoadable {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func modifyAvatarAction(_ sender: UIButton) {
        showModifyAvatarAction()
    }
    
    func showModifyAvatarAction() {
        SheetPop().pop(titles: ["拍摄", "从相册选择"]) { [weak self] selectedIndex in
            guard let self = self else { return }
            if selectedIndex == 0 {
                self.capture()
            } else {
                self.pickPhoto()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationLeft()
        navigation.item.title = "个人中心"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        avatar.bind.cornerRadius(40)
        avatar.layer.borderWidth = 3
        avatar.layer.borderColor = UIColor(0x8BDCCE).cgColor
       
        usernameLabel.superview?.bind.onTap(perform: { _ in
            ModifyUsernameController().bind.push()
        })
        
        avatar.bind.onTap { [weak self] _ in
            guard let self = self else { return }
            self.showModifyAvatarAction()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = UserManager.shared.user {
            avatar.kf.setImage(with: user.avatar.bind.url, placeholder: "place_holder".bind.image)
            usernameLabel.text = user.username
        }
    }
}

extension PersonalInformationController {
    
    private func uploadAvata(model: AppendImageModel) {
        
        Hud.show(.custom(contentView: HudSpinner()) )
        
        model.setupImageData { form in
            UploadManager.upload(form, type: .avatar) { [weak self] res, msg in
                Hud.hide()
                guard let self = self else { return }
                if let res = res {
                    if !res.url.isEmpty {
                        self.avatar.image = model.image
                        UserManager.shared.user?.avatar = res.url
                        Toast.showMsg("修改成功")
                    } else {
                        Toast.showMsg("修改失败")
                    }
                } else {
                    Toast.showMsg(msg ?? "")
                }
            }
        }
    }
    
    func capture() {
        CaptureImage.shared.didSelectedImagePicker = { [weak self] image in
            guard let self = self else { return }
            let model = AppendImageModel()
            model.image = image
            self.uploadAvata(model: model)
        }
        CaptureImage.shared.capture(false)
    }

    func pickPhoto() {
        guard let sender = UIWindow.bind.topViewController() else {
            return
        }
        let config = PhotoConfiguration.default()
        config.allowSelectImage = true
        config.allowSelectVideo = false
        config.maxSelectCount = 1
        let photoPicker = PhotoManager()
        photoPicker.selectImageBlock = { [weak self] (images, _) in
            guard let self = self, let image = images.first else { return }
            let model = AppendImageModel()
            model.image = image.image
            model.asseet = image.asset
            self.uploadAvata(model: model)
        }
        photoPicker.showPhotoLibrary(sender: sender)
    }
}
