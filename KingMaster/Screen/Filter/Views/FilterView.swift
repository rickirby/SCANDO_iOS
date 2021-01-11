//
//  FilterView.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class FilterView: UIView {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didChangeSegment(index: Int)
		case didTapDownload
		case didTapAdjust
		case didTapNext
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	var isV2: Bool = false {
		didSet {
			layoutIfNeeded()
			setNeedsLayout()
		}
	}
	
	// MARK: - Private Properties
	
	private let filtersComponents: [String] = ["Ori", "Crop", "Gray", "AdptvTh", "Dilate", "Erode"]
	private let filtersV2Components: [String] = ["Erode", "RawCont", "FiltCont", "reDraw", "Line", "Segmnt"]
	
	// MARK: - View Components
	
	lazy var segmentControl: UISegmentedControl = {
		let titles = isV2 ? filtersV2Components : filtersComponents
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
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .gray
		activityIndicator.hidesWhenStopped = true
		
		return activityIndicator
	}()
	
	lazy var downloadBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
	
	lazy var adjustBarButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(adjustBarButtonTapped))
	
	lazy var nextBarButton = UIBarButtonItem(image: UIImage(systemName: "arrowtriangle.right.square"), style: .plain, target: self, action: #selector(nextBarButtonTapped))
	
	// MARK: - Public Methods
	
	func showSaveAlert(on vc: UIViewController, error: Error?) {
		AlertView.createSaveImageAlert(vc, didFinishSavingWithError: error)
	}
	
	func startLoading() {
		ThreadManager.executeOnMain {
			self.activityIndicator.startAnimating()
		}
	}
	
	func stopLoading() {
		ThreadManager.executeOnMain {
			self.activityIndicator.stopAnimating()
		}
	}
	
}

extension FilterView {
	
	// MARK: - @Objc Target
	
	@objc func segmentControlChanged() {
		onViewEvent?(.didChangeSegment(index: segmentControl.selectedSegmentIndex))
	}
	
	@objc func adjustBarButtonTapped() {
		onViewEvent?(.didTapAdjust)
	}
	
	@objc func downloadBarButtonTapped() {
		onViewEvent?(.didTapDownload)
	}
	
	@objc func nextBarButtonTapped() {
		onViewEvent?(.didTapNext)
	}
}
