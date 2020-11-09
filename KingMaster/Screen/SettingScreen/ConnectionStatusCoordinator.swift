//
//  ConnectionStatusCoordinator.swift
//  Production
//
//  Created by Ricki Private on 08/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class ConnectionStatusCoordinator: Coordinator {
	
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
		let vc = makeConnectionStatusViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makeConnectionStatusViewController() -> UIViewController {
		let vc = ConnectionStatusViewController()
		vc.onNavigationEvent = { [weak self] (navigationEvent: ConnectionStatusViewController.NavigationEvent) in
			switch navigationEvent {
			case .didTapPair:
				self?.openPair()
			case .didTapReset:
				self?.openReset()
			case .didTapDone, .didTapCancel:
				self?.popViewController()
			}
		}
		
		return vc
	}
	
	private func openPair() {
		
	}
	
	private func openReset() {
		
	}
	
	private func popViewController() {
		Router.shared.popViewController(on: self)
	}
}
