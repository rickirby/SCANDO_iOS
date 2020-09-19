//
//  ThreadManager.swift
//  KingMaster
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ThreadManager {
	
	static func executeOnMain(_ block: @escaping () -> Void) {
		if Thread.isMainThread {
			block()
		} else {
			DispatchQueue.main.async(execute: block)
		}
	}
}
