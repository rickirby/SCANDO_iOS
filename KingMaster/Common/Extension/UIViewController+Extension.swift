//
//  UIViewController+Extension.swift
//  KingMaster
//
//  Created by Ricki Private on 09/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension UIViewController {
	
	func clearTableSelectionOnViewWillAppear(tableView: UITableView) {
		if let selectedIndexPath = tableView.indexPathForSelectedRow {
			if let transitionCoordinator = transitionCoordinator {
				transitionCoordinator.animate(alongsideTransition: { (context) in
					tableView.deselectRow(at: selectedIndexPath, animated: true)
				}, completion: nil)
				
				transitionCoordinator.notifyWhenInteractionChanges { (context) in
					if context.isCancelled {
						tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: .none)
					}
				}
			} else {
				tableView.deselectRow(at: selectedIndexPath, animated: true)
			}
		}
	}
}
