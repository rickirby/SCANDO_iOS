//
//  ScanAlbumsView.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class ScanAlbumsView: View {
	
	// MARK: - Public Properties
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		return tableView
	}()
	
	// MARK: - Life Cycle
	
	override func setViews() {
		configureView()
	}
	
	// MARK: - Public Method
	
	func reloadData() {
		tableView.reloadData()
	}
	
	// MARK: - Private Method
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [tableView])
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.topAnchor),
			tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
}
