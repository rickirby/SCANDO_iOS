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
import CoreLocation

class ConnectionStatusViewController: ViewController<ConnectionStatusView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didTapPair
		case didTapCancel
		case didTapDone
	}
	
	enum Status {
		case directConnected
		case sharedConnected
		case disconnected
		case differentNetwork
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	var connectionStatus: Status = .disconnected {
		didSet {
			configureStatus(for: connectionStatus)
		}
	}
	
	// MARK: - Private Properties
	
	private let locationManager = CLLocationManager()
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureViewEvent()
		askForLocationPermission()
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
		
		screenView.startLoading()
		
		if sharedSSID == "" {
			NetworkRequest.get(url: "http://192.168.4.1/checkresponse") { result in
				ThreadManager.executeOnMain {
					if let message = result["msg"] as? String, message == "OK" {
						self.connectionStatus = .directConnected
					} else {
						self.connectionStatus = .disconnected
						NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "")
						ConnectionUserSetting.shared.save(nil)
					}
					
					self.screenView.stopLoading()
				}
			}
			
		} else {
			if currentSSIDs().first == sharedSSID {
				NetworkRequest.get(url: "http://scandohardware.local/checkresponse") { result in
					ThreadManager.executeOnMain {
						if let message = result["msg"] as? String, message == "OK" {
							self.connectionStatus = .sharedConnected
						} else {
							self.connectionStatus = .disconnected
							NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "")
							ConnectionUserSetting.shared.save(nil)
						}
						
						self.screenView.stopLoading()
					}
				}
			} else {
				connectionStatus = .differentNetwork
				DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
					self.refreshStatus()
				}
			}
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
			
			guard let self = self else {
				return
			}
			
			switch viewEvent {
			
			case .didTapPositive:
				if self.connectionStatus == .disconnected {
					self.onNavigationEvent?(.didTapPair)
				} else if self.connectionStatus == .directConnected || self.connectionStatus == .sharedConnected {
					self.onNavigationEvent?(.didTapDone)
				} else if self.connectionStatus == .differentNetwork {
					self.refreshStatus()
				}
				
			case .didTapNegative:
				if self.connectionStatus == .disconnected {
					self.onNavigationEvent?(.didTapCancel)
				} else {
					self.resetConnection()
				}
			}
		}
	}
	
	private func configureStatus(for status: Status) {
		screenView.configureStatus(for: status)
	}
	
	private func askForLocationPermission() {
		let locStatus = CLLocationManager.authorizationStatus()
		switch locStatus {
		case .notDetermined:
			locationManager.requestAlwaysAuthorization()
			return
		case .denied, .restricted:
			let alert = UIAlertController(title: "Location Services are disabled", message: "Please enable Location Services in your Settings", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(okAction)
			present(alert, animated: true, completion: nil)
			return
		case .authorizedAlways, .authorizedWhenInUse:
			break
		@unknown default:
			break
		}
	}
	
	private func resetConnection() {
		
		AlertView.createConnectionResetAlert(self) {
			if let sharedSSID = ConnectionUserSetting.shared.read(), sharedSSID == "" {
				NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "")
			}
			
			ConnectionUserSetting.shared.save(nil)
			self.screenView.stopLoading()
			self.refreshStatus()
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
	
}
