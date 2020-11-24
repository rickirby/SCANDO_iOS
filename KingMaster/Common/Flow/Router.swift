//
//  Router.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

internal final class Router {
	
	static let shared = Router()
	var window: UIWindow?
	private let navigationController: UINavigationController = UINavigationController()
	
	func setRoot(_ viewController: UIViewController) {
		let isKeyWindowEmpty = UIApplication.shared.windows.first { $0.isKeyWindow } == nil
		
		if !isKeyWindowEmpty, window?.rootViewController != nil {
			guard let snapshot = window?.snapshotView(afterScreenUpdates: true) else {
				return
			}
			
			viewController.view.addSubview(snapshot)
			window?.rootViewController = viewController
			
			UIView.animate(
				withDuration: 0.25,
				animations: {
					snapshot.layer.opacity = 0
					snapshot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
			},
				completion: { (_) in
					snapshot.removeFromSuperview()
			}
			)
		} else {
			window?.rootViewController = viewController
			window?.makeKeyAndVisible()
		}
	}
	
	func push(_ viewController: UIViewController, on coordinator: Coordinator) {
		guard let nav = coordinator.rootViewController as? UINavigationController else {
			return
		}
		
		if nav.viewControllers.count == 0 {
			nav.setViewControllers([viewController], animated: true)
			return
		}
		
		nav.pushViewController(viewController, animated: true)
		nav.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	func present(_ viewController: UIViewController, on target: UIViewController, isAnimated: Bool = true) {
		target.present(viewController, animated: isAnimated, completion: nil)
	}
	
	func dismissTopVC() {
		if var topController = window?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}

			topController.dismiss(animated: true, completion: nil)
		}
	}
	
	func popViewController(on coordinator: Coordinator) {
		guard let nav = coordinator.rootViewController as? UINavigationController else {
			return
		}
		
		nav.popViewController(animated: true)
	}
	
	func popToRootViewController(on coordinator: Coordinator) {
		guard let nav = coordinator.rootViewController as? UINavigationController else {
			return
		}
		
		nav.popToRootViewController(animated: true)
	}
}
