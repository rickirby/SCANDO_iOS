//
//  AlertView.swift
//  KingMaster
//
//  Created by Ricki Private on 11/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class AlertView {
    
    static func createSwipeDeleteAlert(_ target: UIViewController, deleteHanler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: SCANDOConstant.swipeDeleteTitle, message: SCANDOConstant.swipeDeleteMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SCANDOConstant.swipeDeletePositiveAction, style: .destructive) { _ in
            deleteHanler()
        })
        ac.addAction(UIAlertAction(title: SCANDOConstant.swipeDeleteNegativeAction, style: .cancel) { _ in
            cancelHandler()
        })
        
        target.present(ac, animated: true, completion: nil)
    }
	
	static func createSwipeMoreSheet(_ target: UIViewController, renameHandler: @escaping () -> Void, saveHandler: @escaping () -> Void, changeHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.swipeMoreTitle, message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreRenameAction, style: .default) { _ in
			renameHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreSaveAction, style: .default) { _ in
			saveHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreChangeAction, style: .default) { _ in
			changeHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreDeleteAction, style: .destructive) { _ in
			deleteHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreCancelAction, style: .cancel) { _ in
			cancelHandler()
		})
		
		target.present(ac, animated: true, completion: nil)
	}
}
