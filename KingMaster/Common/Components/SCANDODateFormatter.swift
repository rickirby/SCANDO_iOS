//
//  SCANDODateFormatter.swift
//  KingMaster
//
//  Created by Ricki Private on 20/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class SCANDODateFormatter: DateFormatter {
	
	static let shared = SCANDODateFormatter()
	
	override init() {
		super.init()
		
		self.timeZone = .current
		self.dateFormat = "yyyy/MM/dd' 'HH:mm"
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
