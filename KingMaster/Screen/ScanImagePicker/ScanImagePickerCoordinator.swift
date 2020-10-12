//
//  ScanImagePickerCoordinator.swift
//  KingMaster
//
//  Created by Ricki Private on 16/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

class ScanImagePickerCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> ScanImagePickerData)?
	
	private weak var navigationController: UINavigationController?
	private var editScanCoordinator: EditScanCoordinator?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makeViewController()
		
		Router.shared.present(vc, on: self.rootViewController)
	}
	
	private func makeViewController() -> UIViewController {
		let vc = RBScanImagePickerController()
		vc.scanDelegate = self
		
		return vc
	}
	
	private func openEditScan(image: UIImage, quad: Quadrilateral?) {
		editScanCoordinator = nil
		editScanCoordinator = EditScanCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		editScanCoordinator?.passedData = {
			return EditScanCoordinator.EditScanData(image: image, quad: quad, isRotateImage: false, documentGroup: self.passedData?().documentGroup)
		}
		
		editScanCoordinator?.start()
	}
}

extension ScanImagePickerCoordinator: RBScanImagePickerControllerDelegate {
	
	func gotPicture(image: UIImage, quad: Quadrilateral?) {
		openEditScan(image: image, quad: quad)
	}
	
}
