//
//  FilterV2ViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class FilterV2ViewController: ViewController<FilterView> {
	
	// MARK: - Public Properties
	
	var passedData: (() -> FilterCoordinator.FilterData)?
	
	// MARK: - Private Properties
	
	var originalImage: UIImage?
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewState()
		configureLoadBar()
		loadData()
	}
	
	// MARK: - Private Methods
	
	private func configureViewState() {
		screenView.isV2 = true
	}
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.titleView = screenView.segmentControl
		toolbarItems = [screenView.downloadBarButton, spacer, screenView.adjustBarButton]
	}
	
	private func loadData() {
		guard let passedData = passedData?() else {
			return
		}
		
		self.originalImage = passedData.image
		screenView.image = originalImage
	}
}
