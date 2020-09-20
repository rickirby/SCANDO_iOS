//
//  UIView+Shimmering.swift
//  KingMaster
//
//  Created by Ricki Private on 20/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension UIView {
	
	func startShimmering(){
		self.layoutIfNeeded()
		self.backgroundColor = .lightGray
		let light = UIColor.white.cgColor
		let alpha = UIColor.white.withAlphaComponent(0.5).cgColor
		
		let gradient = CAGradientLayer()
		gradient.colors = [alpha, light, alpha]
		gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
		gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
		gradient.locations = [0.25, 0.5, 0.75]
		self.layer.mask = gradient
		
		let animation = CABasicAnimation(keyPath: "locations")
		animation.fromValue = [0.0, 0.1, 0.2]
		animation.toValue = [0.8, 0.9, 1.0]
		animation.duration = 0.3
		animation.repeatCount = .infinity
		gradient.add(animation, forKey: "shimmer")
	}
	
	func stopShimmering(){
		self.backgroundColor = .clear
		self.layer.mask = nil
	}
	
}
