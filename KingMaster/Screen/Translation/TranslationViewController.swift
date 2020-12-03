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
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
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
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: TranslationView.ViewEvent) in
			
			switch viewEvent {
			case .didTapPrint:
				break
			}
		}
	}
}
