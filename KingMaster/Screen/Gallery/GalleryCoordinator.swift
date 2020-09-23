//
//  GalleryCoordinator.swift
//  KingMaster
//
//  Created by Afni Laili on 12/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class GalleryCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> GalleryData)?
	
	private weak var navigationController: UINavigationController?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makeGalleryViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	func makeGalleryViewController() -> UIViewController {
		let vc = GalleryViewController()
		vc.passedData = passedData
		vc.onNavigationEvent = { [weak self] (navigationEvent: GalleryViewController.NavigationEvent) in
			switch navigationEvent {
			case .didDeleteImage:
				NotificationCenter.default.post(name: NSNotification.Name("didFinishDeleteDocument"), object: nil)
				Router.shared.popViewController(on: self!)
			case .didTapEdit:
				print("Tap Edit")
			}
		}
		
		return vc
	}
}
