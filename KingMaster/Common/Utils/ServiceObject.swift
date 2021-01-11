//
//  ServiceObject.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 26/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ServiceObject<T> {
	var onSuccess: ((T) -> Void)?
	var onError: ((Error) -> Void)?
}
