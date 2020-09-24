//
//  PreviewData.swift
//  KingMaster
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

extension PreviewCoordinator {
	
	struct PreviewData {
		var image: UIImage
		var quad: Quadrilateral
		var isEditExistingDocument: Bool = false
		var documentGroup: DocumentGroup?
	}
}
