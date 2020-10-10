//
//  ErodeParamUserSetting.swift
//  Production
//
//  Created by Ricki Private on 10/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ErodeParamUserSetting {
	
	struct ErodeParam {
		var iteration: Int
	}
	
	let key = "erode_param"
	
	static let shared = ErodeParamUserSetting()
	
	func save(_ value: ErodeParam) {
		if let data = try? JSONEncoder().encode(value) {
			UserDefaults.standard.set(data, forKey: key)
		}
	}
	
	func read() -> ErodeParam? {
		guard let data = UserDefaults.standard.value(forKey: key) as? Data, let value = try? JSONDecoder().decode(ErodeParam.self, from: data) else { return nil }
		
		return value
	}
	
	func remove() {
		UserDefaults.standard.removeObject(forKey: key)
	}
}
