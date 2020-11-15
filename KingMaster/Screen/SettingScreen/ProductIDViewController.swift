//
//  ProductIDViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 15/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

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
			case .didTapDone(let productID):
				self?.startConfiguringConnection(productID)
			}
		}
	}
	
	func startConfiguringConnection(_ productID: String) {
		let configuration = NEHotspotConfiguration.init(ssid: productID, passphrase: "abc\(productID)abc", isWEP: false)
		configuration.joinOnce = true

		NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
			if error != nil {
				if error?.localizedDescription == "already associated." {
					
				} else {
					
				}
			} else {
				
			}
		}
	}
}
