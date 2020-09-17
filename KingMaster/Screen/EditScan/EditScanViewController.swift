//
//  EditScanViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 17/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBCameraDocScan

class EditScanViewController: ViewController<EditScanView> {
	
	// MARK: - Public Properties
	
	var passedData: (() -> EditScanData)?
	
	// MARK: - Private Properties
	
	private var image: UIImage?
	private var quad: Quadrilateral?
	private var recentQuad: Quadrilateral?
	
	private var zoomGestureController: ZoomGestureController?
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		loadData()
		configureLoadBar()
		configureZoomGesture()
	}
	
	// MARK: - Private Methods
	
	private func loadData() {
		guard let data = passedData?() else { return }
		image = data.image
		quad = data.quad ?? defaultQuad(forImage: data.image)
		screenView.image = data.image
	}
	
	private func configureLoadBar() {
		title = "Edit Document Points"
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.rightBarButtonItems = [screenView.nextBarButton]
		toolbarItems = [screenView.allAreaBarButton, spacer, screenView.downloadBarButton]
	}
	
	private func configureZoomGesture() {
		guard let image = image else { return }
		zoomGestureController = ZoomGestureController(image: image, quadView: screenView.quadView)
		let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController?.handle(pan:)))
		touchDown.minimumPressDuration = 0
		screenView.addGestureRecognizer(touchDown)
	}
}

extension EditScanViewController {
	
	// MARK: - Quad Processing
	
	private func displayQuad() {
		guard let image = image, let quad = quad else { return }
		let imageSize = image.size
		let imageFrame = CGRect(origin: screenView.quadView.frame.origin, size: CGSize(width: screenView.quadViewWidthConstraint.constant, height: screenView.quadViewHeightConstraint.constant))
		
		let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
		let transforms = [scaleTransform]
		let transformedQuad = quad.applyTransforms(transforms)
		
		screenView.quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
	}
	
	private func defaultQuad(forImage image: UIImage) -> Quadrilateral {
		let topLeft = CGPoint(x: image.size.width / 3.0, y: image.size.height / 3.0)
		let topRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: image.size.height / 3.0)
		let bottomRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
		let bottomLeft = CGPoint(x: image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
		
		let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
		
		return quad
	}
	
	private func allFrameQuad(forImage image: UIImage) -> Quadrilateral {
		let topLeft = CGPoint(x: 0, y: 0)
		let topRight = CGPoint(x: image.size.width, y: 0)
		let bottomRight = CGPoint(x: image.size.width, y: image.size.height)
		let bottomLeft = CGPoint(x: 0, y: image.size.height)
		
		let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
		
		return quad
	}
}
