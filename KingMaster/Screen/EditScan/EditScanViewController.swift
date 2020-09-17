//
//  EditScanViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 17/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBCameraDocScan

class EditScanViewController: ViewController<EditScanView> {
	
	// MARK: - Private Properties
	
	private var image: UIImage?
	private var quad: Quadrilateral?
	private var recentQuad: Quadrilateral?
	
	private var zoomGestureController: ZoomGestureController!
	
	
}
