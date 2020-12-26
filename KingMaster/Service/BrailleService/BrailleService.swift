//
//  BrailleService.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 26/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBImageProcessor

class BrailleService {
	
	var readDot: ReadDot?
	
	init(readDot: ReadDot?) {
		self.readDot = readDot
	}
	
	func getTranslatedBraille(from image: UIImage) -> ServiceObject<String> {
		let serviceObject: ServiceObject<String> = ServiceObject()
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			guard let result = self?.readDot?.translateBraille(from: image) else {
				serviceObject.onError?(BrailleServiceError.gotNilWhenTranslate)
				return
			}
			
			serviceObject.onSuccess?(result)
		}
		
		return serviceObject
	}
}

extension BrailleService {
	enum BrailleServiceError: Error {
		case gotNilWhenTranslate
	}
}
