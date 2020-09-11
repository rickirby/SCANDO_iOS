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
        let ac = UIAlertController(title: SCANDOConstant.swipeDeleteTitle, message: SCANDOConstant.swipeDeleteAlert, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: SCANDOConstant.swipeDeletePositiveAction, style: .destructive) { _ in
            deleteHanler()
        })
        ac.addAction(UIAlertAction(title: SCANDOConstant.swipeDeleteNegativeAction, style: .cancel) { _ in
            cancelHandler()
        })
        
        target.present(ac, animated: true, completion: nil)
    }
	
	static func createSwipeMoreActionBottomSheet(_ target: UIViewController, renameHandler: @escaping () -> Void, saveHandler: @escaping () -> Void, changeHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void) {
		
	}
}
