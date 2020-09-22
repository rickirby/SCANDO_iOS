//
//  GalleryViewController.swift
//  KingMaster
//
//  Created by Afni Laili on 12/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBPhotosGallery
import RBCameraDocScan

class GalleryViewController: RBPhotosGalleryViewController {
	
	var galleryViewDocumentsData: [Document] = []
	var galleryViewImagesData: [UIImage] = []
	
	var passedData: (() -> GalleryCoordinator.GalleryData)?
	
	// MARK: - Private Properties
	
	private var screenView = GalleryView()
	
	// MARK: - Life Cycle
	
	public override func loadView() {
		super.loadView()
		view.addSubview(screenView)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
		prepareData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
	}
	
	// MARK: - Private Methods
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.rightBarButtonItem = screenView.editBarButton
		toolbarItems = [screenView.deleteBarButton, spacer, screenView.downloadBarButton]
	}
	
	private func configureBar() {
		setLargeTitleDisplayMode(.never)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.setToolbarHidden(false, animated: true)
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: GalleryView.ViewEvent) in
			switch viewEvent {
			case .didTapEdit:
				print("Tap Edit")
			case .didTapDownload:
				print("Tap Download")
			case .didTapDelete:
				print("Tap Delete")
			}
		}
	}
	
	private func prepareData() {
		screenView.startLoading()
		
		DispatchQueue.global(qos: .userInitiated).async {
			guard let data = self.passedData?(), let documents = data.documentGroup.documents.allObjects as? [Document] else { return }
			let sortedDocument = documents.sorted {
				$0.date.compare($1.date) == .orderedAscending
			}
			
			self.galleryViewDocumentsData = sortedDocument
			self.galleryViewImagesData = sortedDocument.map {
				
				guard let originalImage = UIImage(data: $0.image.originalImage) else {
					return #imageLiteral(resourceName: "ICON")
				}
				
				let quad = Quadrilateral(topLeft: CGPoint(x: $0.quad.topLeftX, y: $0.quad.topLeftY), topRight: CGPoint(x: $0.quad.topRightX, y: $0.quad.topRightY), bottomRight: CGPoint(x: $0.quad.bottomRightX, y: $0.quad.bottomRightY), bottomLeft: CGPoint(x: $0.quad.bottomLeftX, y: $0.quad.bottomLeftY))
				let processedImage = PerspectiveTransformer.applyTransform(to: originalImage, withQuad: quad)
				
				return processedImage
			}
			
			ThreadManager.executeOnMain {
				self.screenView.stopLoading()
				self.reloadPhotosData()
				self.scrollToPhotos(index: data.selectedIndex, animated: false)
			}
		}
	}
}

extension GalleryViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return galleryViewImagesData
	}
}
