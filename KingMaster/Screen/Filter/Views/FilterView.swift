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
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didChangeSegment(index: Int)
		case didTapDownload
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	var image: UIImage? {
		didSet {
			processedImageView.image = image
		}
	}
	
	// MARK: - View Components
	
	lazy var segmentControl: UISegmentedControl = {
		let titles = ["Ori", "Gray", "AdptvTh"]
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
	
	lazy var processedImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		imageView.isOpaque = true
		imageView.backgroundColor = .systemBackground
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	lazy var downloadBarButton = UIBarButtonItem(image: UIImage(named: "SaveButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
	
	lazy var adjustBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(adjustBarButtonTapped))
	
	// MARK: - Life Cycles
	
	override func setViews() {
		super.setViews()
		
		configureView()
	}
	
	// MARK: - Private Methods
	
	func configureView() {
		backgroundColor = .systemBackground
		
		addAllSubviews(views: [processedImageView])
		
		NSLayoutConstraint.activate([
			processedImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			processedImageView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
			processedImageView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
			processedImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
		])
		
		adjustBarButton.isEnabled = false
	}
}

extension FilterView {
	
	// MARK: - @Objc Target
	
	@objc func segmentControlChanged() {
		onViewEvent?(.didChangeSegment(index: segmentControl.selectedSegmentIndex))
	}
	
	@objc func adjustBarButtonTapped() {
		
	}
	
	@objc func downloadBarButtonTapped() {
		onViewEvent?(.didTapDownload)
	}
}
