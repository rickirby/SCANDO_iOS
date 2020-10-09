//
//  UserSetting.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 09/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

protocol UserSetting {
	
	associatedtype Key
	associatedtype ValueType
	
	func save(_ value: ValueType, forKey key: Key)
	func read(forKey key: Key) -> ValueType?
	func remove(forKey key: Key)
	func removeAll()
}
