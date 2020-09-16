//
//  DocumentGroupCoordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class DocumentGroupCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	private weak var navigationController: UINavigationController?
	private var galleryCoordinator: GalleryCoordinator?
	private var cameraCoordinator: CameraCoordinator?
	private var scanImagePickerCoordinator: ScanImagePickerCoordinator?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makeDocumentGroupViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	private func makeDocumentGroupViewController() -> UIViewController {
		let vc = DocumentGroupViewController()
		vc.onNavigationEvent = { [weak self] (navigationEvent: DocumentGroupViewController.NavigationEvent) in
			switch navigationEvent {
			case .didTapCamera:
				self?.openCamera()
			case .didTapPicker:
				self?.openScanImagePicker()
			case .didSelectRow(index: let index):
				self?.galleryCoordinator = GalleryCoordinator(navigationController: self?.rootViewController as? UINavigationController ?? UINavigationController())
				self?.galleryCoordinator?.start()
			}
		}
		
		return vc
	}
	
	private func openCamera() {
		cameraCoordinator = CameraCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		cameraCoordinator?.start()
	}
	
	private func openScanImagePicker() {
		scanImagePickerCoordinator = ScanImagePickerCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		scanImagePickerCoordinator?.start()
	}
}
