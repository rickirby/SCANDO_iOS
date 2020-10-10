//
//  DilateParamUserSetting.swift
//  Production
//
//  Created by Ricki Private on 10/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class DilateParamUserSetting {
	
	struct DilateParam: Codable {
		var iteration: Int
	}
	
	let key = "dilate_param"
	
	static let shared = DilateParamUserSetting()
	
	func save(_ value: DilateParam) {
		if let data = try? JSONEncoder().encode(value) {
			UserDefaults.standard.set(data, forKey: key)
		}
	}
	
	func read() -> DilateParam? {
		guard let data = UserDefaults.standard.value(forKey: key) as? Data, let value = try? JSONDecoder().decode(DilateParam.self, from: data) else { return nil }
		
		return value
	}
	
	func remove() {
		UserDefaults.standard.removeObject(forKey: key)
	}
}
