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
	private var documentGroupCoordinator: DocumentGroupCoordinator?
	
	func start() {
		let vc = makeViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	private func makeViewController() -> UIViewController {
		let vc = ScanAlbumsViewController()
		vc.onNavigationEvent = { [weak self] (navigationEvent: ScanAlbumsViewController.NavigationEvent) in
			switch navigationEvent {
			case .selectItem(let index):
				self?.documentGroupCoordinator = DocumentGroupCoordinator(navigationController: self?.rootViewController as? UINavigationController ?? UINavigationController())
				self?.documentGroupCoordinator?.start()
			}
		}
		
		return vc
	}
	
}
