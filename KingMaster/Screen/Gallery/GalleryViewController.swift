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
		case didDeleteLastImage
		case didTapEdit(image: UIImage, quad: Quadrilateral, currentDocument: Document)
		#if SANDBOX
		case didOpenDev(processedImage: UIImage)
		#endif
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
		#if PRODUCTION
		toolbarItems = [screenView.downloadBarButton, spacer, screenView.translateBarButton, spacer, screenView.deleteBarButton]
		#elseif SANDBOX
		toolbarItems = [screenView.downloadBarButton, spacer, screenView.devBarButton, spacer, screenView.translateBarButton, spacer, screenView.deleteBarButton]
		#endif
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
				self?.downloadImage()
			case .didTapDelete:
				self?.deleteImage()
			case .didTapTranslate:
				break
			#if SANDBOX
			case .didTapDev:
				self?.openDev()
			#endif
			}
		}
	}
	
	private func loadData() {
		screenView.startLoading()
		
		if let indexOfDocumentGroup = self.passedData?().indexOfDocumentGroup, let cache = GalleryCache.getCache(for: indexOfDocumentGroup) {
			guard let data = self.passedData?() else { return }
			
			self.galleryViewDocumentsData = cache.sortedDocuments
			
			DispatchQueue.main.async { [weak self] in
				self?.galleryViewImagesData = cache.images
				self?.reloadPhotosData()
				self?.scrollToPhotos(index: data.selectedIndex, animated: false)
				self?.screenView.stopLoading()
			}
			
		} else {
			DispatchQueue.global(qos: .userInitiated).async { [weak self] in
				
				autoreleasepool {
					guard let data = self?.passedData?(), let documents = data.documentGroup.documents.allObjects as? [Document] else { return }
					let sortedDocuments = documents.sorted {
						$0.date.compare($1.date) == .orderedAscending
					}
					
					self?.galleryViewDocumentsData = sortedDocuments
					
					self?.galleryViewImagesData.removeAll()
					self?.galleryViewImagesData = sortedDocuments.map {
						guard let thumbnailImage = UIImage(data: $0.thumbnail) else {
							return #imageLiteral(resourceName: "ICON")
						}
						
						return thumbnailImage
					}
					
					GalleryCache.cacheData.append(GalleryCache.GalleryCacheModel(index: data.indexOfDocumentGroup, images: self!.galleryViewImagesData, sortedDocuments: self!.galleryViewDocumentsData))
					
					ThreadManager.executeOnMain {
						self?.screenView.stopLoading()
						self?.reloadPhotosData()
						self?.scrollToPhotos(index: data.selectedIndex, animated: false)
					}
				}
			}
		}
	}
	
	private func downloadImage() {
		screenView.startLoading()
		
		let image = galleryViewImagesData[currentPageIndex]
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
		}
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		screenView.stopLoading()
		screenView.showSaveAlert(on: self, error: error)
    }
	
	private func deleteImage() {
		guard let documentGroup = passedData?().documentGroup, let indexOfDocumentGroup = passedData?().indexOfDocumentGroup else { return }
		screenView.showDeleteAlert(on: self, deleteHandler: {
			if self.galleryViewDocumentsData.count > 1 {
				let documentToDelete = self.galleryViewDocumentsData[self.currentPageIndex]
				self.model.deleteData(documentToDelete: documentToDelete)
				GalleryCache.removeCache(for: indexOfDocumentGroup)
				self.onNavigationEvent?(.didDeleteImage)
			} else {
				self.model.deleteDocumentGroup(documentGroupToDelete: documentGroup)
				GalleryCache.removeCache(for: indexOfDocumentGroup)
				self.onNavigationEvent?(.didDeleteLastImage)
			}
			
		}, cancelHandler: {
			
		})
	}
	
	private func editImage() {
		
		let document = galleryViewDocumentsData[currentPageIndex]
		guard let image = UIImage(data: document.image.originalImage) else { return }
		let quad = Quadrilateral(topLeft: CGPoint(x: document.quad.topLeftX, y: document.quad.topLeftY), topRight: CGPoint(x: document.quad.topRightX, y: document.quad.topRightY), bottomRight: CGPoint(x: document.quad.bottomRightX, y: document.quad.bottomRightY), bottomLeft: CGPoint(x: document.quad.bottomLeftX, y: document.quad.bottomLeftY))
		onNavigationEvent?(.didTapEdit(image: image, quad: quad, currentDocument: document))
		
	}
	
	#if SANDBOX
	private func openDev() {
		onNavigationEvent?(.didOpenDev(processedImage: galleryViewImagesData[currentPageIndex]))
	}
	#endif
}

extension GalleryViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return galleryViewImagesData
	}
}
