//
//  FilterViewController.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class FilterViewController: ViewController<FilterView> {
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
	}
	
	// MARK: - Private Methods
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.titleView = screenView.segmentControl
		toolbarItems = [spacer, screenView.downloadBarButton]
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
