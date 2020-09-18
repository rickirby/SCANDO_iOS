//
//  EditScanCoordinator.swift
//  KingMaster
//
//  Created by Ricki Private on 18/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class EditScanCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> EditScanViewController.EditScanData)?
	
	private weak var navigationController: UINavigationController?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makeEditScanViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	func makeEditScanViewController() -> UIViewController {
		let vc = EditScanViewController()
		vc.passedData = passedData
		
		return vc
	}
}
