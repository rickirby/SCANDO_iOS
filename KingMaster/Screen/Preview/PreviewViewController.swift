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
	
	var passedData: (() -> PreviewCoordinator.PreviewData)?
	
	// MARK: - Private Properties
	
	private var image: UIImage?
	private var processedImage: UIImage?
	private var quad: Quadrilateral?
	private var rotationAngle = Measurement<UnitAngle>(value: 0, unit: .degrees)
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		loadData()
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
			self.reloadImage()
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
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	private func reloadImage() {
		guard let processedImage = processedImage else { return }
		screenView.reloadImage(withImage: processedImage, angle: rotationAngle)
	}
	
	private func saveImage() {
		guard let image = image else { return }
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
		
		reloadImage()
	}
	
	private func rotateLeft() {
		screenView.startLoading()
		rotationAngle.value -= 90
		
		if rotationAngle.value < 0 {
			rotationAngle.value += 360
		}
		
		reloadImage()
	}
	
}
