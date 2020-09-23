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
		
		return vc
	}
}
