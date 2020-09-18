//
//  EditScanData.swift
//  KingMaster
//
//  Created by Ricki Private on 17/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

extension EditScanViewController {
	
	struct EditScanData {
		var image: UIImage
		var quad: Quadrilateral?
		var isRotateImage: Bool = true
	}
	
}
