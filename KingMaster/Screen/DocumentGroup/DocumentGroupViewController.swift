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
		case didSelectRow(index: Int, indexOfDocumentGroup: Int)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	var passedData: (() -> DocumentGroupCoordinator.DocumentGroupData)?
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
		configureViewData()
		configureObserver()
		prepareGalleryData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
	}
	
	override func willMove(toParent parent: UIViewController?) {
		super.willMove(toParent: parent)
		if parent == nil {
			removeObserver()
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
				guard let indexOfDocumentGroup = self?.passedData?().index else { return }
				self?.onNavigationEvent?(.didSelectRow(index: index, indexOfDocumentGroup: indexOfDocumentGroup))
			}
		}
	}
	
	private func configureViewData() {
		screenView.viewDataSupply = {
			guard let documentGroup = self.passedData?().documentGroup, let documents = documentGroup.documents.allObjects as? [Document] else {
				return []
			}
			let sortedDocuments = documents.sorted {
				$0.date.compare($1.date) == .orderedAscending
			}
			
			return sortedDocuments
		}
	}
	
	private func prepareGalleryData() {
		DispatchQueue.global(qos: .utility).async { [weak self] in
			
			autoreleasepool {
				guard let documentGroup = self?.passedData?().documentGroup, let index = self?.passedData?().index, let documents = documentGroup.documents.allObjects as? [Document] else { return }
				
				if GalleryCache.getCache(for: index) == nil {
					let sortedDocuments = documents.sorted {
						$0.date.compare($1.date) == .orderedAscending
					}
					
					let galleryImagesData: [UIImage] = sortedDocuments.map {
						guard let thumbnailImage = UIImage(data: $0.thumbnail) else {
							return #imageLiteral(resourceName: "ICON")
						}
						
						return thumbnailImage
					}
					
					GalleryCache.cacheData.append(GalleryCache.GalleryCacheModel(index: index, images: galleryImagesData, sortedDocuments: sortedDocuments))
				}
			}
		}
	}
	
	private func configureObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(didFinishAddNewDocument), name: NSNotification.Name("didFinishAddNewDocument"), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(didFinishEditDocument), name: NSNotification.Name("didFinishEditDocument"), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(didFinishDeleteDocument), name: NSNotification.Name("didFinishDeleteDocument"), object: nil)
	}
	
	private func removeObserver() {
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("didFinishAddNewDocument"), object: nil)
		
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("didFinishEditDocument"), object: nil)
		
		NotificationCenter.default.removeObserver(self, name: NSNotification.Name("didFinishDeleteDocument"), object: nil)
	}
	
	@objc func didFinishAddNewDocument() {
		screenView.collectionView.reloadData()
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
			self?.screenView.scrollToEnd()
		}
		
		if let passedData = self.passedData?() {
			
			GalleryCache.removeCache(for: passedData.index)
			if passedData.index > 0 {
				GalleryCache.slideDownCache(before: passedData.index)
			}
			
			self.passedData = {
				return DocumentGroupCoordinator.DocumentGroupData(index: 0, documentGroup: passedData.documentGroup)
			}
			
			prepareGalleryData()
		}
	}
	
	@objc func didFinishDeleteDocument() {
		screenView.collectionView.reloadData()
		
		if let passedData = self.passedData?() {
			
//			GalleryCache.removeCache(for: passedData.index)
			
			prepareGalleryData()
		}
	}
	
	@objc func didFinishEditDocument() {
		screenView.collectionView.reloadData()
		
		if let passedData = self.passedData?() {
			
//			GalleryCache.removeCache(for: passedData.index)
//			if passedData.index > 0 {
//				GalleryCache.slideDownCache(before: passedData.index)
//			}
			
			self.passedData = {
				return DocumentGroupCoordinator.DocumentGroupData(index: 0, documentGroup: passedData.documentGroup)
			}
			
			let endDocumentIndex = passedData.documentGroup.documents.count - 1
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
				self?.screenView.scrollToEnd()
				self?.screenView.collectionView.delegate?.collectionView?(self!.screenView.collectionView, didSelectItemAt: IndexPath(row: endDocumentIndex, section: 0))
			}
		}
	}
}
