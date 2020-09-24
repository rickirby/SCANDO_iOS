//
//  UIImage+Extension.swift
//  KingMaster
//
//  Created by Ricki Private on 24/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

extension UIImage {
	
	func defaultThumbnail() -> UIImage? {
		let imageWidth = self.size.width
		let imageHeight = self.size.height
		
		let widthRatio = imageWidth / 200
		let heightRatio = imageHeight / 200
		
		let selectedRatio = min(widthRatio, heightRatio)
		
		return createThumbnail(withSize: CGSize(width: imageWidth / selectedRatio, height: imageHeight / selectedRatio))
	}
}
