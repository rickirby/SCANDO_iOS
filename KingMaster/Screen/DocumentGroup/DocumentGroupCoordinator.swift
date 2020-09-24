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
	
	var passedData: (() -> DocumentGroupData)?
	
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
		vc.passedData = passedData
		vc.onNavigationEvent = { [weak self] (navigationEvent: DocumentGroupViewController.NavigationEvent) in
			switch navigationEvent {
			case .didTapCamera:
				self?.openCamera()
			case .didTapPicker:
				self?.openScanImagePicker()
			case .didSelectRow(let index, let indexOfDocumentGroup):
				self?.openGallery(index: index, indexOfDocumentGroup: indexOfDocumentGroup)
			}
		}
		
		return vc
	}
	
	private func openCamera() {
		cameraCoordinator = nil
		cameraCoordinator = CameraCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		cameraCoordinator?.passedData = {
			return CameraCoordinator.CameraData(documentGroup: self.passedData?().documentGroup)
		}
		cameraCoordinator?.start()
	}
	
	private func openScanImagePicker() {
		scanImagePickerCoordinator = nil
		scanImagePickerCoordinator = ScanImagePickerCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		scanImagePickerCoordinator?.passedData = {
			return ScanImagePickerCoordinator.ScanImagePickerData(documentGroup: self.passedData?().documentGroup)
		}
		scanImagePickerCoordinator?.start()
	}
	
	private func openGallery(index: Int, indexOfDocumentGroup: Int) {
		galleryCoordinator = nil
		galleryCoordinator = GalleryCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		guard let documentGroup = passedData?().documentGroup else { return }
		galleryCoordinator?.passedData = {
			return GalleryCoordinator.GalleryData(documentGroup: documentGroup, indexOfDocumentGroup: indexOfDocumentGroup, selectedIndex: index)
		}
		
		galleryCoordinator?.start()
	}
}
