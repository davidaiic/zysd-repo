//
//  PickImagesView.swift
//  Basic
//
//  Created by wangteng on 2023/3/2.
//

import UIKit
import ZLPhotoBrowser
import Bind
import Lantern

class AddPictureView: UIView {
    
    var configuration = AddPictureConfiguration()
    
    var addImageHandler: (() -> Void)?
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = configuration.spacing
        flowLayout.minimumInteritemSpacing = configuration.spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: AppendImageItemView.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        build()
    }
    
    convenience init(configuration: AddPictureConfiguration) {
        self.init(frame: .zero)
        self.setup(configuration)
    }
    
    func setup(_ configuration: AddPictureConfiguration) {
        self.frame = .init(origin: .zero, size:
                .init(width: configuration.maxWidth, height: configuration.height))
        self.configuration = configuration
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func build() {
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
}

extension AddPictureView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return configuration.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return configuration.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemView = collectionView.dequeueReusableCell(for: indexPath, cellType: AppendImageItemView.self)
        itemView.model = configuration.models[indexPath.row]
        itemView.button.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.configuration.remove(indexPath.row)
            self.collectionView.reloadData()
        }
        return itemView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = configuration.models[indexPath.row]
        switch model.opType {
        case .add:
            if let handler = addImageHandler {
                handler()
            } else {
                showSheetPop()
            }
        case .image:
            if configuration.canBroswer {
                openLantern(with: indexPath.row)
            }
        }
    }
    
    func openLantern(with index: Int) {
        let lantern = Lantern()
        lantern.numberOfItems = {[weak self] in
            guard let self = self else { return 0}
            return self.configuration.imageCount
        }

        lantern.cellClassAtIndex = { _ in
            LoadingImageCell.self
        }
        lantern.reloadCellAtIndex = { [weak self] context in
            guard let self = self else { return }
            guard let lanternCell = context.cell as? LoadingImageCell else {
                return
            }
            lanternCell.index = context.index
            let model = self.configuration.models[context.index]
            lanternCell.imageView.image = model.image
            lanternCell.progressView.isHidden = true
        }
        lantern.transitionAnimator = LanternZoomAnimator(previousView: { [weak self] index -> UIView? in
            guard let self = self else { return nil }
            let cell = self.collectionView.cellForItem(at: IndexPath.init(row: index, section: 0)) as? AppendImageItemView
            return cell?.photoView
        })
        lantern.pageIndicator = LanternDefaultPageIndicator()
        lantern.pageIndex = index
        lantern.show()
    }
}

extension AddPictureView {
    
    func showSheetPop() {
        SheetPop().pop(titles: ["拍摄", "从相册选择"]) { [weak self] selectedIndex in
            guard let self = self else { return }
            if selectedIndex == 0 {
                self.capture()
            } else {
                self.pickPhoto()
            }
        }
    }
    
    func capture() {
        CaptureImage.shared.didSelectedImagePicker = { [weak self] image in
            guard let self = self else { return }
            let asset = AppendImageModel.init(opType: .image)
            asset.image = image
            self.configuration.add(images: [asset])
            self.collectionView.reloadData()
        }
        CaptureImage.shared.capture()
    }
    
    func pickPhoto() {
        guard let sender = UIWindow.bind.topViewController() else {
            return
        }
        let config = PhotoConfiguration.default()
        config.allowSelectImage = true
        config.allowSelectVideo = false
        config.maxSelectCount = configuration.maxImages-configuration.imageCount
        let photoPicker = PhotoManager()
        photoPicker.selectImageBlock = { [weak self] (images, _) in
            guard let self = self else { return }
            let sequence = images.map { image -> AppendImageModel in
                let imageModel = AppendImageModel.init()
                imageModel.image = image.image
                imageModel.opType = .image
                imageModel.asseet = image.asset
                return imageModel
            }
            self.configuration.add(images: sequence)
            self.collectionView.reloadData()
        }
        photoPicker.showPhotoLibrary(sender: sender)
    }
}

class AppendImageItemView: UICollectionViewCell, Reusable {
    
    lazy var photoView: UIImageView = {
        let photoView = UIImageView()
        photoView.layer.cornerRadius = 4
        photoView.layer.masksToBounds = true
        photoView.backgroundColor = .clear
        photoView.contentMode = .scaleAspectFill
        return photoView
    }()
    
    lazy var button: UIButton = {
        let btn = UIButton()
        btn.setImage("add_image_close".bind.image, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func build() {
        self.contentView.addSubview(photoView)
        photoView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        self.contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.top.right.equalTo(0)
            make.width.height.equalTo(18)
        }
    }
    
    var model = AppendImageModel() {
        didSet {
            switch model.opType {
            case .add:
                button.isHidden = true
                photoView.image = "add_pic".bind.image
            case .image:
                button.isHidden = false
                photoView.image = model.image
            }
        }
    }
}
