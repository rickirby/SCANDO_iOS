//
//  DocumentGroupViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBCameraDocScan

class DocumentGroupViewController: ViewController<DocumentGroupView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didTapCamera
		case didTapPicker
		case didSelectRow(index: Int)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	var passedData: (() -> DocumentGroup)?
	var shouldReloadAndScroll = false
	
	// MARK: - Private Properties
	
	private var hasPreparedGalleryData = false
	private var galleryImagesData: [UIImage] = []
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
		configureViewData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
		checkIfShouldReloadAndScroll()
	}
	
	// MARK: - Public Methods
	
	func checkIfShouldReloadAndScroll() {
		
		if shouldReloadAndScroll {
			screenView.collectionView.reloadData()
			shouldReloadAndScroll = false
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				self.screenView.scrollToEnd()
			}
		}
		
	}
	
	// MARK: - Private Methods
	
	private func configureLoadBar() {
		title = "Documents"
		navigationItem.rightBarButtonItems = [screenView.cameraBarButton, screenView.fileBarButton]
	}
	
	private func configureBar() {
		setLargeTitleDisplayMode(.never)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: DocumentGroupView.ViewEvent) in
			switch viewEvent {
			case .didTapCamera:
				self?.onNavigationEvent?(.didTapCamera)
			case .didTapPicker:
				self?.onNavigationEvent?(.didTapPicker)
			case .didSelectRow(let index):
				self?.onNavigationEvent?(.didSelectRow(index: index))
			}
		}
	}
	
	private func configureViewData() {
		screenView.viewDataSupply = {
			guard let documentGroup = self.passedData?(), let documents = documentGroup.documents.allObjects as? [Document] else {
				return []
			}
			let sortedDocuments = documents.sorted {
				$0.date.compare($1.date) == .orderedAscending
			}
			
			return sortedDocuments
		}
	}
	
	private func prepareGalleryData() {
		DispatchQueue.global(qos: .utility).async {
			guard let documentGroup = self.passedData?(), let documents = documentGroup.documents.allObjects as? [Document] else { return }
			
			let sortedDocuments = documents.sorted {
				$0.date.compare($1.date) == .orderedAscending
			}
			
			self.galleryImagesData = sortedDocuments.map {
				
				guard let originalImage = UIImage(data: $0.image.originalImage) else {
					return #imageLiteral(resourceName: "ICON")
				}
				
				let quad = Quadrilateral(topLeft: CGPoint(x: $0.quad.topLeftX, y: $0.quad.topLeftY), topRight: CGPoint(x: $0.quad.topRightX, y: $0.quad.topRightY), bottomRight: CGPoint(x: $0.quad.bottomRightX, y: $0.quad.bottomRightY), bottomLeft: CGPoint(x: $0.quad.bottomLeftX, y: $0.quad.bottomLeftY))
				let processedImage = PerspectiveTransformer.applyTransform(to: originalImage, withQuad: quad)
				
				return processedImage
			}
			
			self.hasPreparedGalleryData = true
		}
	}
}
