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
	
	// MARK: - Private Properties
	
	private var savedSSID = ""
	private var connectionState = false
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewEvent()
		automaticallyAdjustKeyboardLayoutGuide = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: savedSSID)
	}
	
	// MARK: - Private Methods
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: ProductIDView.ViewEvent) in
			switch viewEvent {
			case .didTapDone(let productID):
				self?.startConfiguringConnection(productID)
			}
		}
	}
	
	private func startConfiguringConnection(_ productID: String) {
		
		let ssid = "ESP32"
		let pass = productID
		
		let configuration = NEHotspotConfiguration.init(ssid: ssid, passphrase: pass, isWEP: false)
		configuration.joinOnce = true
		
		NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
			if let error = error as NSError? {
				print("===\(error)")
				self.handleConnection(success: false)
			} else {
				if self.currentSSIDs().first == ssid {
					self.savedSSID = ssid
					self.handleConnection(success: true)
				} else {
					self.handleConnection(success: false)
				}
			}
		}
	}
	
	private func currentSSIDs() -> [String] {
		
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
	
	private func handleConnection(success: Bool) {
		
		screenView.stopLoading()
		
		if success {
			connectionState = true
		} else {
			savedSSID = ""
			connectionState = false
		}
		
	}
}
