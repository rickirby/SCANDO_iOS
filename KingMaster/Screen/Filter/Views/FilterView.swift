//
//  FilterView.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class FilterView: View {
	
	// MARK: - View Components
	
	lazy var segmentControl: UISegmentedControl = {
		let titles = ["Grayscale", "Adapt Th"]
		let segmentControlWidth = UIScreen.main.bounds.width - 100
		let segmentControl = UISegmentedControl(items: titles)
		segmentControl.selectedSegmentIndex = 0
		
		for index in 0..<titles.count {
			segmentControl.setWidth(segmentControlWidth / CGFloat(titles.count), forSegmentAt: index)
		}
		segmentControl.sizeToFit()
		segmentControl.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
		
		return segmentControl
	}()
	
	// MARK: - Life Cycles
	
	override func setViews() {
		super.setViews()
		
		configureView()
	}
	
	// MARK: - Private Methods
	
	func configureView() {
		backgroundColor = .systemBackground
	}
}

extension FilterView {
	
	// MARK: - @Objc Target
	
	@objc func segmentControlChanged() {
		
	}
}
