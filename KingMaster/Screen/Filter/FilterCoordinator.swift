//
//  FilterCoordinator.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class FilterCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	private weak var navigationController: UINavigationController?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makeFilterViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	private func makeFilterViewController() -> UIViewController {
		let vc = FilterViewController()
		
		return vc
	}
}
