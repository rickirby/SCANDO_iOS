//
//  ConnectionModel.swift
//  KingMaster
//
//  Created by Ricki Private on 21/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ConnectionUserSetting {
	
	let key = "shared_ssid"
	
	static let shared = ConnectionUserSetting()
	
	func save(_ value: String?) {
		UserDefaults.standard.set(value, forKey: key)
	}
	
	func read() -> String? {
		return UserDefaults.standard.value(forKey: key) as? String
	}
	
}
