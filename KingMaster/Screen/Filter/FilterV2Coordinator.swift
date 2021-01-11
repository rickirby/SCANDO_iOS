//
//  FilterV2Coordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class FilterV2Coordinator: Coordinator {
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> FilterCoordinator.FilterData)?
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	private var translationCoordinator: TranslationCoordinator?
	
	// MARK: - Life Cycles
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makeFilterV2ViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makeFilterV2ViewController() -> UIViewController {
		let vc = FilterV2ViewController()
		vc.passedData = passedData
		vc.onNavigationEvent = { [weak self] (navigationEvent: FilterV2ViewController.NavigationEvent) in
			switch navigationEvent {
			case .didOpenTranslasion(rawValue: let rawValue, enhancedValue: let enhancedValue):
				self?.openTranslation(rawValue: rawValue, enhancedValue: enhancedValue)
			}
		}
		
		return vc
	}
	
	private func openTranslation(rawValue: String, enhancedValue: String) {
		translationCoordinator = nil
		translationCoordinator = TranslationCoordinator(navigationController: self.rootViewController as? UINavigationController ?? UINavigationController())
		translationCoordinator?.passedData = {
			return TranslationCoordinator.TranslasionData(rawValue: rawValue, enhancedValue: enhancedValue)
		}
		
		translationCoordinator?.start()
	}
	
}

