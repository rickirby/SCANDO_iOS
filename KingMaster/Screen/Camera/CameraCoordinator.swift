//
//  CameraCoordinator.swift
//  KingMaster
//
//  Created by Ricki Private on 16/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

class CameraCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	private weak var navigationController: UINavigationController?
	private var scanImagePickerCoordinator: ScanImagePickerCoordinator?
	private var editScanCoordinator: EditScanCoordinator?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makeViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	private func makeViewController() -> UIViewController {
		let vc = RBCameraViewController()
		vc.delegate = self
		
		return vc
	}
	
	private func openScanImagePicker() {
		scanImagePickerCoordinator = ScanImagePickerCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		scanImagePickerCoordinator?.start()
	}
	
	private func openEditScan(image: UIImage, quad: Quadrilateral?) {
		editScanCoordinator = EditScanCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		editScanCoordinator?.passedData = {
			return EditScanViewController.EditScanData(image: image, quad: quad)
		}
		editScanCoordinator?.start()
	}
}

extension CameraCoordinator: RBCameraViewControllerDelegate {
	func gotCapturedPicture(_ target: UIViewController, image: UIImage, quad: Quadrilateral?) {
		openEditScan(image: image, quad: quad)
	}
	
	func didTapCancel(_ target: UIViewController) {
		Router.shared.popViewController(on: self)
	}
	
	func didTapImagePick(_ target: UIViewController) {
		openScanImagePicker()
	}
}
