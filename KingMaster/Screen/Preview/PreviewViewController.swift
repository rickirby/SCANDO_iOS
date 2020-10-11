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
import RBImageProcessor

class PreviewViewController: ViewController<PreviewView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didFinish(newGroup: Bool, newDocument: Bool)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	var passedData: (() -> PreviewCoordinator.PreviewData)?
	
	// MARK: - Private Properties
	
	private let model = PreviewModel()
	
	private var image: UIImage?
	private var processedImage: UIImage?
	private var quad: Quadrilateral?
	private var rotationAngle = Measurement<UnitAngle>(value: 0, unit: .degrees)
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		loadData()
		configureViewEvent()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
	}
	
	// MARK: - Private Methods
	
	private func loadData() {
		guard let data = passedData?() else { return }
		image = data.image
		quad = data.quad
		
		screenView.startLoading()
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			autoreleasepool {
				
				self?.processedImage = PerspectiveTransformer.applyTransform(to: data.image, withQuad: data.quad)
			}
			
			ThreadManager.executeOnMain {
				self?.reloadImage()
			}
		}
	}
	
	private func configureLoadBar() {
		title = "Preview"
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.rightBarButtonItems = [screenView.doneBarButton]
		toolbarItems = [screenView.rotateRightBarButton, spacer, screenView.downloadBarButton]
	}
	
	private func configureBar() {
		navigationController?.setToolbarHidden(false, animated: true)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: PreviewView.ViewEvent) in
			switch viewEvent {
			case .didTapDone:
				self?.finishImage()
			case .didTapRotateRight:
				self?.rotateRight()
			case .didTapDownload:
				self?.downloadImage()
			}
		}
	}
	
	private func reloadImage() {
		guard let processedImage = processedImage else { return }
		screenView.reloadImage(withImage: processedImage)
	}
	
	private func downloadImage() {
		guard let image = processedImage else { return }
		screenView.startLoading()
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
		}
	}
	
	@objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		screenView.stopLoading()
		screenView.showSaveAlert(error: error)
	}
	
	private func rotateRight() {
		screenView.startLoading()
		rotationAngle.value += 90
		
		if rotationAngle.value == 360 {
			rotationAngle.value = 0
		}
		
		processedImage = processedImage?.rotated(by: Measurement<UnitAngle>(value: 90, unit: .degrees))
		
		reloadImage()
	}
	
	private func finishImage() {
		saveImage() { newGroup, newDocument in
			ThreadManager.executeOnMain {
				self.screenView.stopLoading()
				self.onNavigationEvent?(.didFinish(newGroup: newGroup, newDocument: newDocument))
			}
		}
	}
	
	private func saveImage(completion: ((Bool, Bool) -> Void)?) {
		
		var newGroup = true
		var newDocument = true
		guard let image = image, let processedImage = processedImage, let quad = quad, let passedData = passedData?() else { return }
		
		screenView.startLoading()
		
		if let documentGroup = passedData.documentGroup {
			DispatchQueue.global(qos: .userInitiated).async { [weak self] in
				if let currentDocument = passedData.currentDocument {
					// Edit document case
					self?.model.updateDocument(documentGroup: documentGroup, currentDocument: currentDocument, newQuadrilateral: quad, newRotationAngle: self!.rotationAngle.value, newThumbnailImage: processedImage)
					
					newDocument = false
				} else {
					// Add new document case
					self?.model.addDocumentToDocumentGroup(documentGroup: documentGroup, originalImage: image, thumbnailImage: processedImage, quad: quad, rotationAngle: self!.rotationAngle.value, date: Date())
				}
				
				newGroup = false
				
				completion?(newGroup, newDocument)
			}
		} else {
			// Add new document group / scan album case
			AlertView.createAddNewScanAlbumAlert(self, positiveHandler: {
				let title = $0.isEmpty ? "New Document" : $0
				DispatchQueue.global(qos: .userInitiated).async { [weak self] in
					self?.model.addNewDocumentGroup(name: title, originalImage: image, thumbnailImage: processedImage, quad: quad, rotationAngle: self!.rotationAngle.value, date: Date())
					
					completion?(newGroup, newDocument)
				}
			}, negativeHandler: {})
			
		}
	}
	
}
