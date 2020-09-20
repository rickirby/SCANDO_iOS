//
//  ScanAlbumsModel.swift
//  KingMaster
//
//  Created by Ricki Private on 20/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import CoreData

class ScanAlbumsModel {
	
	// MARK: - Public Properties
	
	enum ModelEvent {
		case insertData
		case deleteData
		case updateData
		case moveData
	}
	
	var onModelEvent: ((ModelEvent) -> Void)?
}
