//
//  PreviewViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 18/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBCameraDocScan

class PreviewViewController: ViewController<PreviewView> {
	
	// MARK: - Public Properties
	
	var passedData: (() -> PreviewCoordinator.PreviewData)?
	
	// MARK: - Private Properties
	
	private var image: UIImage?
	private var processedImage: UIImage?
	private var quad: Quadrilateral?
	private var rotationAngle = Measurement<UnitAngle>(value: 0, unit: .degrees)
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	// MARK: - Private Methods
	
	private func loadData() {
		guard let data = passedData?() else { return }
		image = data.image
		quad = data.quad
	}
	
}
