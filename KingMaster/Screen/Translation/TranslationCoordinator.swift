//
//  TranslationCoordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 02/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class TranslationCoordinator: Coordinator {
	
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
		let vc = makeTranslationViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makeTranslationViewController() -> UIViewController {
		let vc = TranslationViewController()
		vc.onNavigationEvent = { [weak self] (navigationEvent: TranslationViewController.NavigationEvent) in
			
			switch navigationEvent {
			case .openPrint:
				self?.openPrint()
			case .openConnectionStatus:
				self?.openConnectionStatus()
			}
		}
		
		return vc
	}
	
	private func openPrint() {
		
	}
	
	private func openConnectionStatus() {
		connectionStatusCoordinator = nil
		connectionStatusCoordinator = ConnectionStatusCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		
		connectionStatusCoordinator?.start()
	}
}
