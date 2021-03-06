//
//  WifiSelectionTableViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 21/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork
import NetworkExtension

class WifiSelectionTableViewController: UITableViewController {
	
	// MARK: - Public Properties
	
	var onSuccessConnectingWifi: (() -> Void)?
	
	// MARK: - Private Properties
	
	private var selectedIndex: Int?
	private var availableSSID: [String] = []
	private var timer: Timer?
	private var shouldScanOnNext = true
	private var allowScanning = true
	
	private lazy var refreshBarButton: UIBarButtonItem = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refreshBarButtonTapped))
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .gray
		activityIndicator.startAnimating()
		
		return activityIndicator
	}()
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Available Wifi"
		navigationItem.rightBarButtonItem = refreshBarButton
		
		getAvailableWifiList()
		timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
			self.getAvailableWifiList()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		timer?.invalidate()
	}
	
	// MARK: - UITableViewDataSource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return availableSSID.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard indexPath.row < availableSSID.count else {
			return UITableViewCell()
		}
		
		let cell = UITableViewCell()
		cell.textLabel?.text = availableSSID[indexPath.row]
		
		if let selectedIndex = selectedIndex, indexPath.row == selectedIndex {
			let activityIndicator = UIActivityIndicatorView(style: .medium)
			activityIndicator.startAnimating()
			cell.accessoryView = activityIndicator
		}
		
		return cell
	}
	
	// MARK: - UITableViewDelegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		guard indexPath.row < availableSSID.count else {
			return
		}
		
		selectedIndex = indexPath.row
		allowScanning = false
		connectToWifi()
	}
	
	// MARK: -  Private Methods
	
	@objc private func refreshBarButtonTapped() {
		shouldScanOnNext = true
		getAvailableWifiList()
		shouldScanOnNext = false
	}
	
	private func getAvailableWifiList() {
		
		if shouldScanOnNext && allowScanning {
			navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicator), animated: true)
			activityIndicator.startAnimating()
			NetworkRequest.get(url: "http://192.168.4.1/scanwifi") { result in
				guard let wifiList = result["wifilist"] as? [String] else {
					return
				}
				
				self.availableSSID = wifiList
				
				ThreadManager.executeOnMain {
					self.activityIndicator.stopAnimating()
					self.navigationItem.setRightBarButton(self.refreshBarButton, animated: true)
					self.tableView.reloadData()
				}
			}
		}
		
		shouldScanOnNext = true
	}
	
	private func connectToWifi() {
		guard let selectedIndex = selectedIndex, selectedIndex < availableSSID.count else {
			return
		}
		
		AlertView.createConnectToWifiAlert(self, ssidName: availableSSID[selectedIndex], connectHandler: { pass in
			self.tableView.reloadData()
			let postBodyString = "{\"ssid\":\"\(self.availableSSID[selectedIndex])\",\"pass\":\"\(pass)\"}"
			guard let postBodyData = postBodyString.data(using: String.Encoding.utf8) else {
				return
			}
			
			NetworkRequest.post(url: "http://192.168.4.1/connectwifi", body: postBodyData) { result in
				
				ThreadManager.executeOnMain {
					guard let ipAddress = result["msg"] as? String else {
						return
					}
					
					let isSuccess = ipAddress != "failed" && ipAddress != "Could not connect"
					
					if isSuccess {
						NEHotspotConfigurationManager.shared.removeConfiguration(forSSID: "")
					}
					
					AlertView.createConnectToWifiResultAlert(self, ssidName: self.availableSSID[selectedIndex], success: isSuccess, onSuccessHandler: {
						ConnectionUserSetting.shared.save(self.availableSSID[selectedIndex])
						self.dismiss(animated: true, completion: nil)
						self.onSuccessConnectingWifi?()
					}, onErrorHandler: {
						self.allowScanning = true
						self.selectedIndex = nil
						self.tableView.reloadData()
					})
				}
			}
		}, cancelHandler: {
			self.tableView.deselectRow(at: IndexPath(row: self.selectedIndex ?? 0, section: 0), animated: true)
			self.allowScanning = true
			self.selectedIndex = nil
		})
		
	}
	
}
