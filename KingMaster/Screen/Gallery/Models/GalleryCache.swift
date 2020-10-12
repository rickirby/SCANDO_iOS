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
	
	static func removeCache(for index: Int) {
		
		guard let cache = cacheData.first(where: {$0.index == index}), let indexToDelete = cacheData.firstIndex(of: cache), indexToDelete < cacheData.count else { return }
		
		cacheData.remove(at: indexToDelete)
	}
	
	// used if a row removed
	static func slideUpCache(after index: Int) {
		cacheData = cacheData.map {
			if $0.index > index {
				return GalleryCacheModel(index: $0.index - 1, images: $0.images, sortedDocuments: $0.sortedDocuments)
			}
			
			return $0
		}
	}
	
	// used if a row inserted at the top (new data)
	static func slideDownAllCache() {
		cacheData = cacheData.map {
			return GalleryCacheModel(index: $0.index + 1, images: $0.images, sortedDocuments: $0.sortedDocuments)
		}
	}
	
	static func slideDownCache(before index: Int) {
		cacheData = cacheData.map {
			if $0.index < index {
				return GalleryCacheModel(index: $0.index + 1, images: $0.images, sortedDocuments: $0.sortedDocuments)
			}
			
			return $0
		}
	}
}
