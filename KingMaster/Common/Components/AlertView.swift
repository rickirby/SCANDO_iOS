//
//  AlertView.swift
//  KingMaster
//
//  Created by Ricki Private on 11/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class AlertView {
	
	static func createSwipeDeleteAlert(_ target: UIViewController, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.swipeDeleteTitle, message: SCANDOConstant.swipeDeleteMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeDeletePositiveAction, style: .destructive) { _ in
			deleteHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeDeleteNegativeAction, style: .cancel) { _ in
			cancelHandler()
		})
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createSwipeMoreSheet(_ target: UIViewController, renameHandler: @escaping () -> Void, saveHandler: @escaping () -> Void, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreRenameAction, style: .default) { _ in
			renameHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreSaveAction, style: .default) { _ in
			saveHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreDeleteAction, style: .destructive) { _ in
			deleteHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.swipeMoreCancelAction, style: .cancel) { _ in
			cancelHandler()
		})
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createBarDeleteAlert(_ target: UIViewController, isSingular: Bool, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.barDeleteTitle, message: isSingular ? SCANDOConstant.singleBarDeleteMessage : SCANDOConstant.pluralBarDeletelMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: SCANDOConstant.barDeletePositiveAction, style: .destructive) { _ in
			deleteHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.barDeleteNegativeAction, style: .cancel) { _ in
			cancelHandler()
		})
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createGalleryDeleteAlert(_ target: UIViewController, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.galleryDeleteTitle, message: SCANDOConstant.galleryDeleteMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: SCANDOConstant.galleryDeletePositiveAction, style: .destructive) { _ in
			deleteHandler()
		})
		ac.addAction(UIAlertAction(title: SCANDOConstant.galleryDeleteNegativeAction, style: .cancel) { _ in
			cancelHandler()
		})
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createSaveImageAlert(_ target: UIViewController, isOriginalImage: Bool = false, didFinishSavingWithError error: Error?) {
		let ac = UIAlertController(title: error == nil ? SCANDOConstant.saveSuccessTitle : SCANDOConstant.saveErrorTitle, message: error == nil ? (isOriginalImage ? SCANDOConstant.saveOriginalSuccessMessage : SCANDOConstant.saveProcessedSuccessMessage) : error?.localizedDescription, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: SCANDOConstant.saveAction, style: .default, handler: nil))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createSaveAllImageAlert(_ target: UIViewController, count: Int) {
		let ac = UIAlertController(title: SCANDOConstant.saveSuccessTitle, message: String(count) + (count > 1 ? SCANDOConstant.saveAllImagesSuccessMessage : SCANDOConstant.saveAllImageSuccessMessage) , preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: SCANDOConstant.saveAction, style: .default, handler: nil))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createRenameAlert(_ target: UIViewController, currentName: String, positiveHandler: @escaping (String) -> Void, negativeHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.renameTitle, message: currentName, preferredStyle: .alert)
		ac.addTextField { (textField) in
			textField.placeholder = SCANDOConstant.renamePlaceholder
			textField.autocapitalizationType = .words
		}
		ac.addAction(UIAlertAction(title: SCANDOConstant.renamePositiveAction, style: .default, handler: { _ in
			guard let newName = ac.textFields?[0].text else { return }
			positiveHandler(newName)
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.renameNegativeAction, style: .cancel, handler: { _ in
			negativeHandler()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createAddNewScanAlbumAlert(_ target: UIViewController, positiveHandler: @escaping (String) -> Void, negativeHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.addNewScanAlbumTitle, message: SCANDOConstant.addNewScanAlbumMessage, preferredStyle: .alert)
		ac.addTextField {
			$0.placeholder = SCANDOConstant.addNewScanAlbumPlaceholder
			$0.autocapitalizationType = .words
		}
		ac.addAction(UIAlertAction(title: SCANDOConstant.addNewScanAlbumPositiveAction, style: .default, handler: { _ in
			guard let textField = ac.textFields?[0] else { return }
			positiveHandler(textField.text ?? "")
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.addNewScanAlbumNegativeAction, style: .cancel, handler: { _ in
			negativeHandler()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createAdaptiveParamAlert(_ target: UIViewController, currentType: Int?, currentBlockSize: Int?, currentConstant: Double?, setHandler: @escaping (UITextField, UITextField, UITextField) -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.setAdaptiveTitle, message: SCANDOConstant.setAdaptiveMessage, preferredStyle: .alert)
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setAdaptiveTypePlaceholder
			if let type = currentType {
				$0.text = String(type)
			}
		}
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setAdaptiveBlockSizePlaceholder
			if let blockSize = currentBlockSize {
				$0.text = String(blockSize)
			}
		}
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setAdaptiveConstantPlaceholder
			if let constant = currentConstant {
				$0.text = String(constant)
			}
		}
		ac.addAction(UIAlertAction(title: SCANDOConstant.setAdaptivePositiveAction, style: .default, handler: { _ in
			guard let textField0 = ac.textFields?[0], let textField1 = ac.textFields?[1], let textField2 = ac.textFields?[2] else { return }
			setHandler(textField0, textField1, textField2)
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.setAdaptiveNegativeAction, style: .cancel, handler: { _ in
			cancelHandler()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createAdaptiveParamErrorAlert(_ target: UIViewController) {
		let ac = UIAlertController(title: SCANDOConstant.setAdaptiveParamErrorTitle, message: SCANDOConstant.setAdaptiveParamErrorMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createDilateParamAlert(_ target: UIViewController, currentIteration: Int?, setHandler: @escaping (UITextField) -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.setDilateTitle, message: SCANDOConstant.setDilateMessage, preferredStyle: .alert)
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setDilateIterationPlaceholder
			if let iteration = currentIteration {
				$0.text = String(iteration)
			}
		}
		ac.addAction(UIAlertAction(title: SCANDOConstant.setDilatePositiveAction, style: .default, handler: { _ in
			guard let textField = ac.textFields?[0] else { return }
			setHandler(textField)
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.setDilateNegativeAction, style: .cancel, handler: { _ in
			cancelHandler()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createErodeParamAlert(_ target: UIViewController, currentIteration: Int?, setHandler: @escaping (UITextField) -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.setErodeTitle, message: SCANDOConstant.setErodeMessage, preferredStyle: .alert)
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setErodeIterationPlaceholder
			if let iteration = currentIteration {
				$0.text = String(iteration)
			}
		}
		ac.addAction(UIAlertAction(title: SCANDOConstant.setErodePositiveAction, style: .default, handler: { _ in
			guard let textField = ac.textFields?[0] else { return }
			setHandler(textField)
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.setErodeNegativeAction, style: .cancel, handler: { _ in
			cancelHandler()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createBlobAnalysisParamAlert(_ target: UIViewController, currentMinArea: Double?, currentMaxArea: Double?, currentCircleSize: Double?, currentSpaceForGroupingSameRowCols: Double?, currentMaxDotSpaceInterDot: Double?, currentDefaultDotSpaceInterDot: Double?, setHandler: @escaping (UITextField, UITextField, UITextField, UITextField, UITextField, UITextField) -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.setBlobAnalysisParamTitle, message: SCANDOConstant.setBlobAnalysisParamMessage, preferredStyle: .alert)
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setBlobAnalysisMinAreaPlaceholder
			if let minArea = currentMinArea {
				$0.text = String(minArea)
			}
		}
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setBlobAnalysisMaxAreaPlaceholder
			if let maxArea = currentMaxArea {
				$0.text = String(maxArea)
			}
		}
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setBlobAnalysisCircleSizePlaceholder
			if let circleSize = currentCircleSize {
				$0.text = String(circleSize)
			}
		}
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setBlobAnalysisMaxSpaceForGroupingSameRowColsPlaceholder
			if let spaceForGroupingSameRowCols = currentSpaceForGroupingSameRowCols {
				$0.text = String(spaceForGroupingSameRowCols)
			}
		}
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setBlobAnalysisMaxDotSpaceInterDotPlaceholder
			if let maxDotSpaceInterDot = currentMaxDotSpaceInterDot {
				$0.text = String(maxDotSpaceInterDot)
			}
		}
		ac.addTextField {
			$0.placeholder = SCANDOConstant.setBlobAnalysisDefaultDotSpaceInterDotPlaceholder
			if let defaultDotSpaceInterDot = currentDefaultDotSpaceInterDot {
				$0.text = String(defaultDotSpaceInterDot)
			}
		}
		ac.addAction(UIAlertAction(title: SCANDOConstant.setBlobAnalysisPositiveAction, style: .default, handler: { _ in
			guard let textField0 = ac.textFields?[0], let textField1 = ac.textFields?[1], let textField2 = ac.textFields?[2], let textField3 = ac.textFields?[3], let textField4 = ac.textFields?[4], let textField5 = ac.textFields?[5] else { return }
			setHandler(textField0, textField1, textField2, textField3, textField4, textField5)
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.setBlobAnalysisNegativeAction, style: .cancel, handler: { _ in
			cancelHandler()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createConnectionModeAlert(_ target: UIViewController, directConnectHandler: @escaping () -> Void, sharedConnectionHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: SCANDOConstant.connectionModeTitle, message: SCANDOConstant.connectionModeMessage, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectionModeDirectAction, style: .default, handler: { _ in
			directConnectHandler()
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectionModeSharedAction, style: .default, handler: { _ in
			sharedConnectionHandler()
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectionModeCancelActiion, style: .cancel, handler: { _ in
			cancelHandler()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createConnectionResetAlert(_ target: UIViewController, resetHandler: @escaping () -> Void, cancelHandler: (() -> Void)? = nil) {
		let ac = UIAlertController(title: SCANDOConstant.connectionResetTitle, message: SCANDOConstant.connectionResetMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectionResetDesctructiveAction, style: .destructive, handler: { _ in
			resetHandler()
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectionModeCancelActiion, style: .cancel, handler: { _ in
			cancelHandler?()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createConnectToWifiAlert(_ target: UIViewController, ssidName: String, connectHandler: @escaping (String) -> Void, cancelHandler: (() -> Void)? = nil) {
		let ac = UIAlertController(title: SCANDOConstant.connectToWifiAskPasswordTitle, message: SCANDOConstant.connectToWifiAskPasswordMessage + ssidName, preferredStyle: .alert)
		ac.addTextField {
			$0.placeholder = "Password"
		}
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectToWifiAskPasswordConnectAction, style: .default, handler: { _ in
			guard let textField = ac.textFields?.first else {
				return
			}
			
			connectHandler(textField.text ?? "")
		}))
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectToWifiAskPasswordCancelAction, style: .cancel, handler: { _ in
			cancelHandler?()
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
	
	static func createConnectToWifiResultAlert(_ target: UIViewController, ssidName: String, success: Bool, onSuccessHandler: @escaping () -> Void, onErrorHandler: @escaping () -> Void) {
		let ac = UIAlertController(title: success ? SCANDOConstant.connectToWifiSuccessTitle : SCANDOConstant.connectToWifiErrorTitle, message: success ? SCANDOConstant.connectToWifiSuccessMessage + ssidName: SCANDOConstant.connectToWifiErrorMessage, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: SCANDOConstant.connectToWifiResultOkAction, style: .default, handler: { _ in
			if success {
				onSuccessHandler()
			} else {
				onErrorHandler()
			}
		}))
		
		target.present(ac, animated: true, completion: nil)
	}
}
