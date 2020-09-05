//
//  MyViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 05/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class MyViewController: ViewController<MyView> {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		title = "Succeed"
		setNavigationBarColor(backgroundColor: .red, textColor: .white, tintColor: .white)
	}


}

