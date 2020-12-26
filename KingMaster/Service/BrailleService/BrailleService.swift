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
	
	func getTranslatedBraille(from image: UIImage) -> ServiceObject<(String, String)> {
		let serviceObject: ServiceObject<(String, String)> = ServiceObject()
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			guard let rawResult = self?.readDot?.translateBraille(from: image) else {
				serviceObject.onError?(BrailleServiceError.gotNilWhenTranslate)
				return
			}
			
			let enhancedResult = rawResult.removeExtraWhiteSpaces()
			
			serviceObject.onSuccess?((rawResult, enhancedResult))
		}
		
		return serviceObject
	}
	
	private func enhanceTranslasionResult(from text: String) -> String {
		return text
			.replacingOccurrences(of: "\n", with: "")
			.removeExtraWhiteSpaces()
	}
}

extension String {
	
	func removeExtraWhiteSpaces() -> String {
		return self.replacingOccurrences(of: "[\\s]+", with: " ", options: .regularExpression, range: nil)
	}
	
}

extension BrailleService {
	enum BrailleServiceError: Error {
		case gotNilWhenTranslate
	}
}
