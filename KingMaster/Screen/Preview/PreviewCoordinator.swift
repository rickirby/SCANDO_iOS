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
			case .didFinish(let newGroup, let newDocument):
				if newGroup {
					Router.shared.popToRootViewController(on: self!)
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
						NotificationCenter.default.post(name: NSNotification.Name("didFinishAddNewDocumentGroup"), object: nil)
					}
				} else {
					guard let nav = self?.rootViewController as? UINavigationController, let vc = nav.viewControllers[1] as? DocumentGroupViewController else { return }
//					vc.shouldReloadAndScroll = true
					NotificationCenter.default.post(name: NSNotification.Name("didFinishAddNewDocument"), object: nil)
					nav.popToViewController(vc, animated: true)
				}
				
			}
		}
		
		return vc
	}
}
