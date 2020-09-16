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
	
	// MARK: - Private Properties
	
	private var screenView: GalleryView {
		return view as! GalleryView
	}
	
	// MARK: - Life Cycle
	
	public override func loadView() {
		super.loadView()
		view = GalleryView()
	}
}

extension GalleryViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return dummyData
	}
}
