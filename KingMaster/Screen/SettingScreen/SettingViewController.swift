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
	
	// MARK: - Life Cycles
}
