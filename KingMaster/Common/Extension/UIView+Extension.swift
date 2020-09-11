//
//  UIView+Extension.swift
//  KingMaster
//
//  Created by Ricki Private on 11/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
