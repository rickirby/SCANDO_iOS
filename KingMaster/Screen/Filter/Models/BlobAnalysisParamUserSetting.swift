//
//  BlobAnalysisParamUserSetting.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 20/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class BlobAnalysisParamUserSetting {
	
	struct BlobAnalysisParam: Codable {
		var minAreaContourFilter: Double
		var maxAreaContourFilter: Double
		var redrawCircleSize: Double
		var maxSpaceForGroupingSameRowAndCols: Double
		var maxDotSpaceInterDot: Double
		var defaultDotSpaceInterDot: Double
	}
	
	let key = "blob_analysis_param"
	
	static let shared = BlobAnalysisParamUserSetting()
	
	func save(_ value: BlobAnalysisParam) {
		if let data = try? JSONEncoder().encode(value) {
			UserDefaults.standard.set(data, forKey: key)
		}
	}
	
	func read() -> BlobAnalysisParam? {
		guard let data = UserDefaults.standard.value(forKey: key) as? Data, let value = try? JSONDecoder().decode(BlobAnalysisParam.self, from: data) else { return nil }
		
		return value
	}
	
	func remove() {
		UserDefaults.standard.removeObject(forKey: key)
	}
	
}
