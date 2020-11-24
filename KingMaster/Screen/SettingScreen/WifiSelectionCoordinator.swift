//
//  WifiSelectionCoordinator.swift
//  KingMaster
//
//  Created by Ricki Private on 21/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class WifiSelectionCoordinator: Coordinator {
	
	// MARK: - Public Properties
	
	var onSuccessConnectingWifi: (() -> Void)?
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	
	// MARK: - Life Cycles
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makeWifiSelectionViewController()
		
		Router.shared.present(vc, on: rootViewController, isAnimated: true)
	}
	
	func makeWifiSelectionViewController() -> UIViewController {
		let vc = WifiSelectionTableViewController()
		vc.onSuccessConnectingWifi = { [weak self] in
			self?.onSuccessConnectingWifi?()
		}
		let navVC = UINavigationController(rootViewController: vc)
		
		return navVC
	}
}
