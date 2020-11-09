//
//  SettingModel.swift
//  KingMaster
//
//  Created by Ricki Private on 07/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class SettingModel {
	
	struct SettingTableData {
		let sectionTitle: String
		let rowsData: [SettingTableRowData]
	}
	
	struct SettingTableRowData {
		let title: String
		let navigationEvent: SettingViewController.NavigationEvent
	}
	
	func getTableData() -> [SettingTableData] {
		return [
			SettingTableData(sectionTitle: "General", rowsData: [
				SettingTableRowData(title: "About", navigationEvent: .didTapAbout),
				SettingTableRowData(title: "Help", navigationEvent: .didTapHelp)
			]),
			SettingTableData(sectionTitle: "Connection", rowsData: [
				SettingTableRowData(title: "Connection Setting", navigationEvent: .didTapConnectionSetting)
			])
		]
	}
}
