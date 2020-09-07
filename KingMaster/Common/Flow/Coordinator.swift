//
//  Coordinator.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

protocol Coordinator {

    var rootViewController: UIViewController { get }

    func start()
}
