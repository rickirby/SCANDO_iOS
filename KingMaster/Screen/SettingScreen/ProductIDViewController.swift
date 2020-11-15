//
//  ProductIDViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 15/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class ProductIDViewController: ViewController<ProductIDView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didDismiss
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewEvent()
	}
	
	// MARK: - Private Methods
	
	func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: ProductIDView.ViewEvent) in
			switch viewEvent {
			case .didTapDone:
				self?.startConfiguringConnection()
			}
		}
	}
	
	func startConfiguringConnection() {
		
	}
}
