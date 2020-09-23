//
//  GalleryCache.swift
//  KingMaster
//
//  Created by Ricki Private on 23/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class GalleryCache {
	
	struct GalleryCacheModel {
		let index: Int
		var images: [UIImage]
		var sortedDocuments: [Document]
	}
	
	static var cacheData: [GalleryCacheModel] = []
	
	static func getCache(for index: Int) -> GalleryCacheModel? {
		
		guard let cache = cacheData.first(where: {$0.index == index}) else {
			return nil
		}
		
		return cache
	}
}
