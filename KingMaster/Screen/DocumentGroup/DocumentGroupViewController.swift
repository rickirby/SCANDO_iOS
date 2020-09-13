//
//  DocumentGroupViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class DocumentGroupViewController: ViewController<DocumentGroupView> {
	
    // MARK: - Public Properties
    
    enum NavigationEvent {
        case didSelectRow(index: Int)
    }
    
    var onNavigationEvent: ((NavigationEvent) -> Void)?
    
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadNavigationBar()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureNavigationBar()
        configureViewEvent()
	}
	
	// MARK: - Private Methods
	
	private func configureLoadNavigationBar() {
		title = "Documents"
	}
	
	private func configureNavigationBar() {
		setLargeTitleDisplayMode(.never)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
	}
    
    private func configureViewEvent() {
        screenView.onViewEvent = { [weak self] (viewEvent: DocumentGroupView.ViewEvent) in
            switch viewEvent {
            case .didSelectRow(let index):
                self?.onNavigationEvent?(.didSelectRow(index: index))
                print("Document Group VC Select")
            }
        }
    }
}
