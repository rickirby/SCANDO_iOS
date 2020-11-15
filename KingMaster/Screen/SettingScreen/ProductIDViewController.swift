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
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "ESP32")
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
		//		let configuration = NEHotspotConfiguration.init(ssid: productID, passphrase: "abc\(productID)abc", isWEP: false)
		let configuration = NEHotspotConfiguration.init(ssid: "ESP32", passphrase: productID, isWEP: false)
		configuration.joinOnce = true
		
		NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
			if let error = error as NSError? {
				// failure
				print("FAIL2")
			} else {
				if self.currentSSIDs().first == "ESP32" {
					// Real success
					print("REALSUCCESS")
				} else {
					// Failure
					print("REALFAIL")
				}
			}
		}
	}
	
	func currentSSIDs() -> [String] {
		
		guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
			return []
		}
		
		return interfaceNames.compactMap { name in
			guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
				return nil
			}
			guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
				return nil
			}
			return ssid
		}
	}
}
