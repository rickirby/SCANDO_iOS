//
//  SettingView.swift
//  KingMaster
//
//  Created by Ricki Private on 07/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class SettingView: View {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didSelectRow(indexPath: IndexPath)
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	var viewDataSupply: (() -> [[String]])?
	
	// MARK: - View Components
	
	lazy var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.tableFooterView = UIView()
		
		return tableView
	}()
	
	// MARK: - Life Cycles
	
	override func setViews() {
		configureView()
		configureTableView()
	}
	
	// MARK: - Private Methods
	
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
	
	private func configureTableView() {
		
	}
}
