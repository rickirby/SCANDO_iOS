//
//  ProductIDCoordinator.swift
//  KingMaster
//
//  Created by Ricki Private on 15/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ProductIDCoordinator: Coordinator {
	
	// MARK: - Public Properties
	
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
		let vc = makeProductIDViewController()
		
		Router.shared.present(vc, on: rootViewController, isAnimated: true)
	}
	
	// MARK: - Private Methods
	
	private func makeProductIDViewController() -> UIViewController {
		let vc = ProductIDViewController()
		vc.onNavigationEvent = { [weak self] (navigationEvent: ProductIDViewController.NavigationEvent) in
			switch navigationEvent {
			
			case .directConnection:
				break
			case .sharedConnection(printerSSID: let printerSSID):
				break
			}
		}
		
		return vc
	}
	
	private func dismissViewController() {
		Router.shared.dismissTopVC()
	}
}
