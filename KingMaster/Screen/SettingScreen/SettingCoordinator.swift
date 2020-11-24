//
//  SettingCoordinator.swift
//  Production
//
//  Created by Ricki Private on 08/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class SettingCoordinator: Coordinator {
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	private var connectionStatusCoordinator: ConnectionStatusCoordinator?
	
	// MARK: - Life Cycles
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makeSettingViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makeSettingViewController() -> UIViewController {
		let vc = SettingViewController()
		vc.onNavigationEvent = { [weak self] (navigationEvent: SettingViewController.NavigationEvent) in
			switch navigationEvent {
			case .didTapAbout:
				self?.openAbout()
			case .didTapHelp:
				self?.openHelp()
			case .didTapConnectionSetting:
				self?.openConnectionSetting()
			}
		}
		
		return vc
	}
	
	private func openAbout() {
		
	}
	
	private func openHelp() {
		
	}
	
	private func openConnectionSetting() {
		connectionStatusCoordinator = nil
		connectionStatusCoordinator = ConnectionStatusCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		
		connectionStatusCoordinator?.start()
	}
}
