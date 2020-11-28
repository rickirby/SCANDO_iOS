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
		case directConnection
		case sharedConnection
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	// MARK: - Private Properties
	
	private var printerSSID = ""
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewEvent()
		automaticallyAdjustKeyboardLayoutGuide = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
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
		
		let ssid = productID
		let pass = "pass" + productID
		
		let configuration = NEHotspotConfiguration.init(ssid: ssid, passphrase: pass, isWEP: false)
		configuration.joinOnce = true
		
		NEHotspotConfigurationManager.shared.apply(configuration) { (error) in
			if let error = error as NSError? {
				print("===\(error)")
				self.handleConnection(success: false)
			} else {
				if self.currentSSIDs().first == ssid {
					self.printerSSID = ssid
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
			AlertView.createConnectionModeAlert(self, directConnectHandler: {
				ConnectionUserSetting.shared.save("")
                NetworkRequest.get(url: "http://192.168.4.1/directconnection")
				self.onNavigationEvent?(.directConnection)
			}, sharedConnectionHandler: {
				ConnectionUserSetting.shared.save(self.printerSSID)
				self.onNavigationEvent?(.sharedConnection)
			}, cancelHandler: {
				self.dismiss(animated: true) {
					ConnectionUserSetting.shared.save(nil)
					NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "")
				}
			})

		} else {
			ConnectionUserSetting.shared.save(nil)
		}
		
	}
}

// value shared connected
// nil default value, not connected, connection error. should be show first time view
// "" direct connection
