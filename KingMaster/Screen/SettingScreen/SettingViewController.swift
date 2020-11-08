//
//  SettingViewController.swift
//  KingMaster
//
//  Created by Ricki Private on 07/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class SettingViewController: ViewController<SettingView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didTapAbout
		case didTapHelp
		case didTapConnectionSetting
	}
	
	var onNavigationEvent: ((NavigationEvent) -> ())?
	
	// MARK: - Private Properties
	
	let model = SettingModel()
	var tableData: [SettingModel.SettingTableData] = []
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureModel()
		configureViewEvent()
		configureViewData()
	}
	
	// MARK: - Private Methods
	
	private func configureModel() {
		tableData = model.getTableData()
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: SettingView.ViewEvent) in
			switch viewEvent {
			case .didSelectRow(indexPath: let indexPath):
				guard indexPath.section < self?.tableData.count ?? 0,
					let rowData = self?.tableData[indexPath.section].rowsData,
					indexPath.row < rowData.count else {
					return
				}
				
				self?.onNavigationEvent?(rowData[indexPath.row].navigationEvent)
			}
		}
	}
	
	private func configureViewData() {
		screenView.viewDataSupplyTableTitle = {
			let tableTitle: [[String]] = self.tableData.map { $0.rowsData.map { $0.title } }
			
			return tableTitle
		}
		
		screenView.viewDataSupplySectionTitle = {
			let sectionTitle: [String] = self.tableData.map { $0.sectionTitle }
			
			return sectionTitle
		}
	}
	
}
