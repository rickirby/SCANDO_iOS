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

class PreviewViewController: ViewController<PreviewView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didFinish(newGroup: Bool)
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
		
		DispatchQueue.global(qos: .userInitiated).async {
			self.processedImage = PerspectiveTransformer.applyTransform(to: data.image, withQuad: data.quad)
			ThreadManager.executeOnMain {
				self.reloadImage()
			}
		}
	}
	
	private func configureLoadBar() {
		title = "Preview"
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.rightBarButtonItems = [screenView.doneBarButton]
		toolbarItems = [screenView.translateBarButton, spacer, screenView.rotateLeftBarButton, spacer, screenView.rotateRightBarButton, spacer, screenView.downloadBarButton]
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
			case .didTapRotateLeft:
				self?.rotateLeft()
			case .didTapRotateRight:
				self?.rotateRight()
			case .didTapDownload:
				self?.saveImage()
			}
		}
	}
	
	private func reloadImage() {
		guard let processedImage = processedImage else { return }
		screenView.reloadImage(withImage: processedImage)
	}
	
	private func saveImage() {
		guard let image = processedImage else { return }
		screenView.startLoading()
		
		DispatchQueue.global(qos: .userInitiated).async {
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
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
	
	private func rotateLeft() {
		screenView.startLoading()
		rotationAngle.value -= 90
		
		if rotationAngle.value < 0 {
			rotationAngle.value += 360
		}
		
		processedImage = processedImage?.rotated(by: Measurement<UnitAngle>(value: -90, unit: .degrees))
		
		reloadImage()
	}
	
	
	private func finishImage() {
		screenView.startLoading()
		DispatchQueue.global(qos: .userInitiated).async {
			var newGroup = true
			guard let image = self.image, let processedImage = self.processedImage, let thumbnailImage = processedImage.createThumbnail(withSize: CGSize(width: processedImage.size.width / 15, height: processedImage.size.height / 15)), let quad = self.quad else { return }
			if let documentGroup = self.passedData?().documentGroup {
				self.model.addDocumentToDocumentGroup(documentGroup: documentGroup, originalImage: image, thumbnailImage: thumbnailImage, quad: quad, rotationAngle: self.rotationAngle.value, date: Date())
				newGroup = false
			} else {
				self.model.addNewDocumentGroup(name: "Scando Document", originalImage: image, thumbnailImage: thumbnailImage, quad: quad, rotationAngle: self.rotationAngle.value, date: Date())
			}
			
			ThreadManager.executeOnMain {
				self.screenView.stopLoading()
				self.onNavigationEvent?(.didFinish(newGroup: newGroup))
			}
		}
		
		
	}
	
}
