//
//  PreviewCoordinator.swift
//  KingMaster
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class PreviewCoordinator: Coordinator {
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> PreviewData)?
	
	private weak var navigationController: UINavigationController?
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	func start() {
		let vc = makePreviewViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	func makePreviewViewController() -> UIViewController {
		let vc = PreviewViewController()
		vc.passedData = passedData
		vc.onNavigationEvent = { [weak self] (navigationEvent: PreviewViewController.NavigationEvent) in
			switch navigationEvent {
			case .didFinish:
				Router.shared.popToRootViewController(on: self!)
			}
		}
		
		return vc
	}
}
