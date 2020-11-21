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
	private var connectionStatusViewController: ConnectionStatusViewController?
	private var productIDCoordinator: ProductIDCoordinator?
	private var wifiSelectionCoordinator: WifiSelectionCoordinator?
	
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
		self.connectionStatusViewController = vc
		
		return vc
	}
	
	private func openPair() {
		productIDCoordinator = nil
		productIDCoordinator = ProductIDCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		productIDCoordinator?.onSelectDirectConnection = { [weak self] in
			self?.notifyDirectConnection()
		}
		productIDCoordinator?.onSelectSharedConnection = { [weak self] in
			self?.openWifiSelection()
		}
		
		productIDCoordinator?.start()
	}
	
	private func openReset() {
		
	}
	
	private func popViewController() {
		Router.shared.popViewController(on: self)
	}
	
	private func notifyDirectConnection() {
		connectionStatusViewController?.refreshStatus()
	}
	
	private func openWifiSelection() {
		wifiSelectionCoordinator = nil
		wifiSelectionCoordinator = WifiSelectionCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		
		wifiSelectionCoordinator?.start()
	}
}
