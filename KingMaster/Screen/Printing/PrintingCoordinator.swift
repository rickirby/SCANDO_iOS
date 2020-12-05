//
//  PrintingCoordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 04/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class PrintingCoordinator: Coordinator {
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makePrintingViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makePrintingViewController() -> UIViewController {
		let vc = PrintingViewController()
		
		return vc
	}
}
