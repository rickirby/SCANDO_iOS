//
//  EditScanCoordinator.swift
//  KingMaster
//
//  Created by Ricki Private on 18/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBCameraDocScan

class EditScanCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> EditScanData)?
	
	private weak var navigationController: UINavigationController?
	private var previewCoordinator: PreviewCoordinator?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makeEditScanViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	private func makeEditScanViewController() -> UIViewController {
		let vc = EditScanViewController()
		vc.passedData = passedData
		vc.onNavigationEvent = { [weak self] (navigationEvent: EditScanViewController.NavigationEvent) in
			switch navigationEvent {
				
			case .didTapDone(let image, let quad):
				self?.openPreview(image: image, quad: quad)
			}
		}
		
		return vc
	}
	
	private func openPreview(image: UIImage, quad: Quadrilateral) {
		previewCoordinator = PreviewCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		previewCoordinator?.passedData = {
			return PreviewCoordinator.PreviewData(image: image, quad: quad)
		}
		
		previewCoordinator?.start()
	}
}
