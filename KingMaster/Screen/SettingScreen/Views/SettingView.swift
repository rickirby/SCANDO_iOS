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
	var viewDataSupplyTableTitle: (() -> [[String]])?
	var viewDataSupplySectionTitle: (() -> [String])?
	
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
		tableView.delegate = self
		tableView.dataSource = self
	}
	
}

extension SettingView: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewDataSupplyTableTitle?().count ?? 0
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard section < viewDataSupplySectionTitle?().count ?? 0 else {
			return nil
		}
		return viewDataSupplySectionTitle?()[section]
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 38.0
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let tableData = viewDataSupplyTableTitle?(),
			section < tableData.count else {
			return 0
		}
		
		return tableData[section].count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell()
		guard let tableData = viewDataSupplyTableTitle?(),
			indexPath.section < tableData.count,
			indexPath.row < tableData[indexPath.section].count else {
			return cell
		}
		
		cell.textLabel?.text = tableData[indexPath.section][indexPath.row]
		cell.accessoryType = .disclosureIndicator
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		onViewEvent?(.didSelectRow(indexPath: indexPath))
	}
	
}
