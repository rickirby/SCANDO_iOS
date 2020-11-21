//
//  WifiSelectionTableViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 21/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class WifiSelectionTableViewController: UITableViewController {
	
	// MARK: - Private Properties
	
	private var selectedIndex: Int?
	private var availableSSID: [String] = ["Satu", "Dua", "Tiga"]
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = "Available Wifi"
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// TODO: make request available wifi and distribute to availableSSID properties
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
		tableView.reloadData()
	}
	
}
