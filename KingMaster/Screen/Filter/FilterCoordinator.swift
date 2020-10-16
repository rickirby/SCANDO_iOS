//
//  FilterCoordinator.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class FilterCoordinator: Coordinator {
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> FilterData)?
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	
	// MARK: - Life Cycles
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makeFilterViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makeFilterViewController() -> UIViewController {
		let vc = FilterViewController()
		vc.passedData = passedData
		
		return vc
	}
	
}
