//
//  AppCoordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		return UIViewController()
	}
	
	// MARK: - Private Properties
	
	private var scanAlbumsCoordinator: ScanAlbumsCoordinator?
	
	// MARK: - Public Methods
	
	func start() {
		showMain()
	}
	
	// MARK: - Private Methods
	
	private func showMain() {
		scanAlbumsCoordinator = nil
		scanAlbumsCoordinator = ScanAlbumsCoordinator()
		
		guard let scanAlbumsCoordinator = scanAlbumsCoordinator else {
			return
		}
		
		scanAlbumsCoordinator.start()
		Router.shared.setRoot(scanAlbumsCoordinator.rootViewController)
	}
	
}
