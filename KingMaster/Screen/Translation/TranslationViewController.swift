//
//  TranslationViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 01/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class TranslationViewController: ViewController<TranslationView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case openPrint(data: String )
		case openConnectionStatus
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	var passedData: (() -> TranslationCoordinator.TranslasionData)?
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
		configureView()
		automaticallyAdjustKeyboardLayoutGuide = true
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
	}
	
	// MARK: - Private Methods
	
	private func configureLoadBar() {
		title = "Translation"
		navigationItem.rightBarButtonItem = screenView.printBarButton
	}
	
	private func configureBar() {
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.setToolbarHidden(true, animated: true)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: TranslationView.ViewEvent) in
			
			switch viewEvent {
			case .didTapPrint:
				self?.openPrint()
			}
		}
	}
	
	private func configureView() {
		guard let passedData = passedData?() else {
			return
		}
		
		screenView.resultTextView.text = passedData.rawValue
	}
	
	private func openPrint() {
		
		screenView.startLoading()
		
		ConnectionStatusModel.shared.checkConnectionStatus { status in
			
			ThreadManager.executeOnMain {
				self.screenView.stopLoading()
				switch status {
				
				case .directConnected, .sharedConnected:
					self.onNavigationEvent?(.openPrint(data: self.screenView.resultTextView.text))
				default:
					self.onNavigationEvent?(.openConnectionStatus)
				}
			}
		}
	}
}
