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
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> CameraData)?
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	private var scanImagePickerCoordinator: ScanImagePickerCoordinator?
	private var editScanCoordinator: EditScanCoordinator?
	
	// MARK: - Life Cycles
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makeViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makeViewController() -> UIViewController {
		let vc = RBCameraViewController()
		vc.delegate = self
		
		return vc
	}
	
	private func openScanImagePicker() {
		scanImagePickerCoordinator = nil
		scanImagePickerCoordinator = ScanImagePickerCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		
		scanImagePickerCoordinator?.start()
	}
	
	private func openEditScan(image: UIImage, quad: Quadrilateral?) {
		editScanCoordinator = nil
		editScanCoordinator = EditScanCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		editScanCoordinator?.passedData = {
			return EditScanCoordinator.EditScanData(image: image, quad: quad, isRotateImage: true, documentGroup: self.passedData?().documentGroup)
		}
		
		editScanCoordinator?.start()
	}
	
}

extension CameraCoordinator: RBCameraViewControllerDelegate {
	
	// MARK: - RBCameraViewController delegate method
	
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
