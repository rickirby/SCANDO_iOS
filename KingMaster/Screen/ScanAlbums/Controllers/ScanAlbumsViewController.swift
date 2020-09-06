//
//  ScanAlbumsViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class ScanAlbumsViewController: ViewController<ScanAlbumsView> {
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureNavigationBar()
	}
	
	// MARK: - Private Method
	
	func configureNavigationBar() {
		title = "Scan Albums"
		setLargeTitleDisplayMode(.always)
		navigationItem.rightBarButtonItems = [screenView.cameraBarButton, screenView.fileBarButton]
	}
}
