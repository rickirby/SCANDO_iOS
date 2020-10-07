//
//  FilterViewController.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBImageProcessor

class FilterViewController: ViewController<FilterView> {
	
	// MARK: - Public Properties
	
	var passedData: (() -> FilterCoordinator.FilterData)?
	
	// MARK: - Private Properties
	
	var originalImage: UIImage?
	var grayImage: UIImage?
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		loadData()
		configureViewEvent()
	}
	
	// MARK: - Private Methods
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.titleView = screenView.segmentControl
		toolbarItems = [spacer, screenView.downloadBarButton]
	}
	
	private func loadData() {
		guard let passedData = passedData?() else { return }
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			self?.originalImage = passedData.image
			self?.grayImage = ConvertColor.makeGray(from: passedData.image)
			
			ThreadManager.executeOnMain {
				self?.screenView.image = self?.originalImage
			}
		}
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: FilterView.ViewEvent) in
			switch viewEvent {
			case .didChangeSegment(let index):
				print(index)
			case .didTapDownload:
				self?.downloadImage()
			}
		}
	}
	
	private func downloadImage() {
		
	}
}
