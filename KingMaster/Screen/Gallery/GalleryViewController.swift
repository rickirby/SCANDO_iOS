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
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didDeleteImage
		case didTapEdit(image: UIImage, quad: Quadrilateral, currentDocument: Document)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	var galleryViewDocumentsData: [Document] = []
	var galleryViewImagesData: [UIImage] = []
	
	var passedData: (() -> GalleryCoordinator.GalleryData)?
	
	// MARK: - Private Properties
	
	private var screenView = GalleryView()
	private let model = GalleryModel()
	
	// MARK: - Life Cycle
	
	public override func loadView() {
		super.loadView()
		view.addSubview(screenView.activityIndicator)
		
		NSLayoutConstraint.activate([
			screenView.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			screenView.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
		loadData()
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
				self?.editImage()
			case .didTapDownload:
				self?.saveImage()
			case .didTapDelete:
				self?.deleteImage()
			}
		}
	}
	
	private func loadData() {
		screenView.startLoading()
		
		if let indexOfDocumentGroup = self.passedData?().indexOfDocumentGroup, let cache = GalleryCache.getCache(for: indexOfDocumentGroup) {
			guard let data = self.passedData?() else { return }
			
			self.galleryViewDocumentsData = cache.sortedDocuments
			
			DispatchQueue.main.async {
				self.galleryViewImagesData = cache.images
				self.reloadPhotosData()
				self.scrollToPhotos(index: data.selectedIndex, animated: false)
				self.screenView.stopLoading()
			}
			
		} else {
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
				
				GalleryCache.cacheData.append(GalleryCache.GalleryCacheModel(index: data.indexOfDocumentGroup, images: self.galleryViewImagesData, sortedDocuments: self.galleryViewDocumentsData))
				
				ThreadManager.executeOnMain {
					self.screenView.stopLoading()
					self.reloadPhotosData()
					self.scrollToPhotos(index: data.selectedIndex, animated: false)
				}
			}
		}
	}
	
	private func saveImage() {
		screenView.startLoading()
		
		let image = galleryViewImagesData[currentPageIndex]
		
		DispatchQueue.global(qos: .userInitiated).async {
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
		}
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		screenView.stopLoading()
		screenView.showSaveAlert(on: self, error: error)
    }
	
	private func deleteImage() {
		guard let indexOfDocumentGroup = passedData?().indexOfDocumentGroup else { return }
		screenView.showDeleteAlert(on: self, deleteHandler: {
			let documentToDelete = self.galleryViewDocumentsData[self.currentPageIndex]
			self.model.deleteData(documentToDelete: documentToDelete)
			GalleryCache.removeCache(for: indexOfDocumentGroup)
			self.onNavigationEvent?(.didDeleteImage)
		}, cancelHandler: {
			
		})
	}
	
	private func editImage() {
		
		let document = galleryViewDocumentsData[currentPageIndex]
		guard let image = UIImage(data: document.image.originalImage) else { return }
		let quad = Quadrilateral(topLeft: CGPoint(x: document.quad.topLeftX, y: document.quad.topLeftY), topRight: CGPoint(x: document.quad.topRightX, y: document.quad.topRightY), bottomRight: CGPoint(x: document.quad.bottomRightX, y: document.quad.bottomRightY), bottomLeft: CGPoint(x: document.quad.bottomLeftX, y: document.quad.bottomLeftY))
		onNavigationEvent?(.didTapEdit(image: image, quad: quad, currentDocument: document))
		
	}
}

extension GalleryViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return galleryViewImagesData
	}
}
