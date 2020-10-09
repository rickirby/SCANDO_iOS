//
//  FilterUserSetting.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 09/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class FilterUserSettting: UserSetting {
	
	static let shared = FilterUserSettting()
	
	enum Key: String, CaseIterable {
		case adaptiveType = "adaptive_type"
		case adaptiveBlockSize = "adaptive_blocksize"
		case adaptiveConstant = "adaptive_constant"
	}
	
	typealias ValueType = Int
	
	func save(_ value: Int, forKey key: FilterUserSettting.Key) {
		UserDefaults.standard.set(value, forKey: key.rawValue)
	}
	
	func read(forKey key: FilterUserSettting.Key) -> Int? {
		return UserDefaults.standard.value(forKey: key.rawValue) as? Int
	}
	
	func remove(forKey key: FilterUserSettting.Key) {
		UserDefaults.standard.removeObject(forKey: key.rawValue)
	}
	
	func removeAll() {
		for key in Key.allCases {
			remove(forKey: key)
		}
	}
	
}
