//
//  GalleryViewController.swift
//  KingMaster
//
//  Created by Afni Laili on 12/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBPhotosGallery

class GalleryViewController: RBPhotosGalleryViewController {
	
	var dummyData: [UIImage] = [#imageLiteral(resourceName: "ICON"), #imageLiteral(resourceName: "ICON"), #imageLiteral(resourceName: "ICON")]
}

extension GalleryViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return dummyData
	}
}
