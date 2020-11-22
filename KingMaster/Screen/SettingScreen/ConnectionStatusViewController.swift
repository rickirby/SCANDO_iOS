//
//  ConnectionStatusViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 08/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

class ConnectionStatusViewController: ViewController<ConnectionStatusView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didTapPair
		case didTapCancel
		case didTapDone
	}
	
	enum Status {
		case connected
		case disconnected
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	var connectionStatus: Status = .disconnected {
		didSet {
			configureStatus(for: connectionStatus)
		}
	}
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewEvent()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
		refreshStatus()
	}
	
	// MARK: - Public Methods
	
	func refreshStatus() {
		
		guard let sharedSSID = ConnectionUserSetting.shared.read() else {
			connectionStatus = .disconnected
			return
		}
		
		if sharedSSID == "" {
			screenView.startLoading()
			NetworkRequest.get(url: "http://scandohardware.local/checkresponse") { result in
				ThreadManager.executeOnMain {
					if let message = result["msg"] as? String, message == "OK" {
						self.connectionStatus = .connected
					} else {
						self.connectionStatus = .disconnected
						NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "")
						ConnectionUserSetting.shared.save(nil)
					}
					
					self.screenView.stopLoading()
				}
			}
			
		} else {
			screenView.configureStatus(for: .connected)
		}
		
	}
	
	// MARK: - Private Methods
	
	private func configureBar() {
		navigationController?.setNavigationBarHidden(true, animated: true)
		navigationController?.setToolbarHidden(true, animated: true)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: ConnectionStatusView.ViewEvent) in
			switch viewEvent {
			case .didTapPositive:
				if self?.connectionStatus ?? .disconnected == .disconnected {
					self?.onNavigationEvent?(.didTapPair)
				} else {
					self?.onNavigationEvent?(.didTapDone)
				}
			case .didTapNegative:
				if self?.connectionStatus ?? .disconnected == .disconnected {
					self?.onNavigationEvent?(.didTapCancel)
				} else {
					self?.resetConnection()
				}
			}
		}
	}
	
	private func configureStatus(for status: Status) {
		screenView.configureStatus(for: status)
	}
	
	private func resetConnection() {
		
		AlertView.createConnectionResetAlert(self) {
			if let sharedSSID = ConnectionUserSetting.shared.read(), sharedSSID == "" {
				NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "")
			}
			
			ConnectionUserSetting.shared.save(nil)
		}
	}
	
}
