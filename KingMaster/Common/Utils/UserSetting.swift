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
	associatedtype Type
	
	func save(_ value: Type, forKey key: Key)
	func read(forKey key: Key) -> Type?
	func remove(forKey key: Key)
	func removeAll()
}
