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
	
	// MARK: - Public Properties
	
	var rootViewController: UIViewController {
		guard let navigationController = navigationController else {
			return UIViewController()
		}
		
		return navigationController
	}
	
	var passedData: (() -> PreviewData)?
	
	// MARK: - Private Properties
	
	private weak var navigationController: UINavigationController?
	
	// MARK: - Life Cycles
	
	init(navigationController: UINavigationController) {
		self.navigationController = navigationController
	}
	
	// MARK: - Public Methods
	
	func start() {
		let vc = makePreviewViewController()
		
		Router.shared.push(vc, on: self)
	}
	
	// MARK: - Private Methods
	
	private func makePreviewViewController() -> UIViewController {
		let vc = PreviewViewController()
		vc.passedData = passedData
		vc.onNavigationEvent = { [weak self] (navigationEvent: PreviewViewController.NavigationEvent) in
			switch navigationEvent {
			case .didFinish(let newGroup, let newDocument):
				self?.finishImage(newGroup: newGroup, newDocument: newDocument)
			}
		}
		
		return vc
	}
	
	private func finishImage(newGroup: Bool, newDocument: Bool) {
		if newGroup {
			Router.shared.popToRootViewController(on: self)
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				NotificationCenter.default.post(name: NSNotification.Name("didFinishAddNewDocumentGroup"), object: nil)
			}
		} else {
			guard let nav = rootViewController as? UINavigationController, let vc = nav.viewControllers[1] as? DocumentGroupViewController else { return }
			
			if newDocument {
				NotificationCenter.default.post(name: NSNotification.Name("didFinishAddNewDocument"), object: nil)
			} else {
				NotificationCenter.default.post(name: NSNotification.Name("didFinishEditDocument"), object: nil)
			}
			
			nav.popToViewController(vc, animated: true)
		}
	}
	
}
