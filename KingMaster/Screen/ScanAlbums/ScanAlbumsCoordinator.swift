//
//  ScanAlbumsCoordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ScanAlbumsCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		return navigationController
	}
	
	private let navigationController: UINavigationController = UINavigationController()
	
	func start() {
		let vc = makeViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	private func makeViewController() -> UIViewController {
		let vc = ScanAlbumsViewController()
		
		return vc
	}
	
}
