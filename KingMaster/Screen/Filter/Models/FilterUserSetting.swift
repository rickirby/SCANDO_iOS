//
//  FilterUserSetting.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 09/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class AdaptiveParamUserSettting {
	
	struct AdaptiveParam: Codable {
		var type: Int
		var blockSize: Int
		var constant: Double
	}
	
	let key = "adaptive_param"
	
	static let shared = AdaptiveParamUserSettting()
	
	func save(_ value: AdaptiveParam) {
		if let data = try? JSONEncoder().encode(value) {
			UserDefaults.standard.set(data, forKey: key)
		}
	}
	
	func read() -> AdaptiveParam? {
		guard let data = UserDefaults.standard.value(forKey: key) as? Data, let value = try? JSONDecoder().decode(AdaptiveParam.self, from: data) else { return nil }
		
		return value
	}
	
	func remove() {
		UserDefaults.standard.removeObject(forKey: key)
	}
	
}
