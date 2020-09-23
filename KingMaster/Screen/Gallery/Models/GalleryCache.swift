//
//  GalleryCache.swift
//  KingMaster
//
//  Created by Ricki Private on 23/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class GalleryCache {
	
	struct GalleryCacheModel: Equatable {
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
	
	static func removeCache(for index: Int) -> Bool {
		
		guard let cache = cacheData.first(where: {$0.index == index}), let indexToDelete = cacheData.firstIndex(of: cache), indexToDelete < cacheData.count else {
			return false
		}
		
		cacheData.remove(at: indexToDelete)
		
		return true
	}
}
