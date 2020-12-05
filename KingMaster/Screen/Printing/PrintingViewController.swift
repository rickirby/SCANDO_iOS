//
//  PrintingViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 04/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class PrintingViewController: ViewController<PrintingView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case donePrinting
		case cancelPrinting
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	var passedData: (() -> String)?
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
		configureSendData()
	}
	
	// MARK: - Private Methods
	
	private func configureBar() {
		navigationController?.setNavigationBarHidden(true, animated: true)
		navigationController?.setToolbarHidden(true, animated: true)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = false
	}
	
	private func configureSendData() {
		
		screenView.startLoading()
		screenView.printingState = .connecting
		
		ConnectionStatusModel.shared.checkConnectionStatus { status in
			
			ThreadManager.executeOnMain {
				switch status {
				
				case .directConnected, .sharedConnected:
					self.screenView.printingState = .printingProgress
					self.sendData(isDirectConnected: status == .directConnected)
					
				default:
					break
				}
			}
		}
	}
	
	private func sendData(isDirectConnected: Bool = false) {
		guard let data = passedData?() else {
			return
		}
		
		let postBodyString = "{\"data\":\"\(data)\"}"
		guard let postBodyData = postBodyString.data(using: String.Encoding.utf8) else {
			return
		}
		
		NetworkRequest.post(url: (isDirectConnected ? "http://192.168.4.1" : "http://scandohardware.local") + "/senddata", body: postBodyData) { result in
			
			ThreadManager.executeOnMain {
				self.screenView.stopLoading()
				guard let msg = result["msg"] as? String, msg == "OK" else {
					return
				}
				
				self.screenView.printingState = .printingDone
			}
			
		}
	}
}
