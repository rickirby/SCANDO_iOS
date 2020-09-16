//
//  ScanAlbumsCoordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

class ScanAlbumsCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		return navigationController
	}
	
	private let navigationController: UINavigationController = UINavigationController()
	private var documentGroupCoordinator: DocumentGroupCoordinator?
	private var cameraCoordinator: CameraCoordinator?
	private var scanImagePickerCoordinator: ScanImagePickerCoordinator?
	
	func start() {
		let vc = makeViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	private func makeViewController() -> UIViewController {
		let vc = ScanAlbumsViewController()
		vc.onNavigationEvent = { [weak self] (navigationEvent: ScanAlbumsViewController.NavigationEvent) in
			switch navigationEvent {
			case .didTapCamera:
				self?.openCamera()
			case .didTapPicker:
				self?.openScanImagePicker()
			case .didSelectRow(let index):
				self?.openDocumentGroup(index: index)
			}
		}
		
		return vc
	}
	
	private func openCamera() {
		cameraCoordinator = CameraCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		cameraCoordinator?.start()
	}
	
	private func openDocumentGroup(index: Int) {
		documentGroupCoordinator = DocumentGroupCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		documentGroupCoordinator?.start()
	}
	
	private func openScanImagePicker() {
		scanImagePickerCoordinator = ScanImagePickerCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		scanImagePickerCoordinator?.start()
	}
	
}


