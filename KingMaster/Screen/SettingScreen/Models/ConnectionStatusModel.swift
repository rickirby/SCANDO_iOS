//
//  ConnectionStatusModel.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 01/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import NetworkExtension
import CoreLocation

class ConnectionStatusModel {
	
	enum Status {
		case directConnected
		case sharedConnected
		case disconnected
		case differentNetwork
	}
	
	static let shared = ConnectionStatusModel()
	
	func checkConnectionStatus(onComplete: ((Status) -> Void)? = nil) {
		guard let sharedSSID = ConnectionUserSetting.shared.read() else {
			onComplete?(.disconnected)
			return
		}
		
		if sharedSSID == "" {
			NetworkRequest.get(url: "http://192.168.4.1/checkresponse") { result in
				ThreadManager.executeOnMain {
					if let message = result["msg"] as? String, message == "OK" {
						onComplete?(.directConnected)
					} else {
						onComplete?(.disconnected)
					}
				}
			}
			
		} else {
			if currentSSIDs().first == sharedSSID {
				NetworkRequest.get(url: "http://scandohardware.local/checkresponse") { result in
					ThreadManager.executeOnMain {
						if let message = result["msg"] as? String, message == "OK" {
							onComplete?(.sharedConnected)
						} else {
							onComplete?(.disconnected)
						}
					}
				}
			} else {
				onComplete?(.differentNetwork)
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
	
}
