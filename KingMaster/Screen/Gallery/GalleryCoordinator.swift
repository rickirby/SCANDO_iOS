//
//  GalleryCoordinator.swift
//  KingMaster
//
//  Created by Afni Laili on 12/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

class GalleryCoordinator: Coordinator {
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> GalleryData)?
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	private var editScanCoordinator: EditScanCoordinator?
	private var filterCoordinator: FilterCoordinator?
	private var translationCoordinator: TranslationCoordinator?
	
	// MARK: - Life Cycles
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makeGalleryViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makeGalleryViewController() -> UIViewController {
		let vc = GalleryViewController()
		vc.passedData = passedData
		vc.onNavigationEvent = { [weak self] (navigationEvent: GalleryViewController.NavigationEvent) in
			switch navigationEvent {
			case .didDeleteImage:
				NotificationCenter.default.post(name: NSNotification.Name("didFinishDeleteDocument"), object: nil)
				Router.shared.popViewController(on: self!)
			case .didDeleteLastImage:
				Router.shared.popToRootViewController(on: self!)
			case .didTapEdit(let image, let quad, let currentDocument):
				self?.openEditScan(image: image, quad: quad, currentDocument: currentDocument)
			#if SANDBOX
			case .didOpenDev(let processedImage):
				self?.openDev(processedImage)
			#endif
			case .didOpenTranslation:
				self?.openTranslation()
			}
		}
		
		return vc
	}
	
	private func openEditScan(image: UIImage, quad: Quadrilateral?, currentDocument: Document) {
		editScanCoordinator = nil
		editScanCoordinator = EditScanCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		editScanCoordinator?.passedData = {
			return EditScanCoordinator.EditScanData(image: image, quad: quad, isRotateImage: false, documentGroup: self.passedData?().documentGroup, currentDocument: currentDocument)
		}
		
		editScanCoordinator?.start()
	}
	
	#if SANDBOX
	private func openDev(_ processedImage: UIImage) {
		filterCoordinator = nil
		filterCoordinator = FilterCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		filterCoordinator?.passedData = {
			return FilterCoordinator.FilterData(image: processedImage)
		}
		
		filterCoordinator?.start()
	}
	#endif
	
	private func openTranslation() {
		translationCoordinator = nil
		translationCoordinator = TranslationCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		
		translationCoordinator?.start()
	}
}
