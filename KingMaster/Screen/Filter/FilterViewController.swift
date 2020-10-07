//
//  FilterViewController.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class FilterViewController: ViewController<FilterView> {
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
	}
	
	// MARK: - Private Methods
	
	func configureLoadBar() {
		navigationItem.titleView = screenView.segmentControl
	}
}
