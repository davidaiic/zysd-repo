//
//  Typealias.swift
//  Basic
//
//  Created by wangteng on 2023/3/2.
//

import ZLPhotoBrowser

typealias PhotoConfiguration = ZLPhotoConfiguration
typealias PhotoManager = ZLPhotoPreviewSheet

func configurePhoto() {
    ZLPhotoUIConfiguration.default().navBarColor = UIColor(named: "barTintColor")!
}
