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
	private var printingCoordinator: PrintingCoordinator?
	
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
			case .openPrint(let data):
				self?.openPrint(data)
			case .openConnectionStatus:
				self?.openConnectionStatus()
			}
		}
		
		return vc
	}
	
	private func openPrint(_ data: String) {
		printingCoordinator = nil
		printingCoordinator = PrintingCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		printingCoordinator?.passedData = {
			return data
		}
		
		printingCoordinator?.start()
	}
	
	private func openConnectionStatus() {
		connectionStatusCoordinator = nil
		connectionStatusCoordinator = ConnectionStatusCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		
		connectionStatusCoordinator?.start()
	}
}
