//
//  GalleryModel.swift
//  KingMaster
//
//  Created by Ricki Private on 23/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class GalleryModel {
	
	// MARK: - Public Method
	
	func deleteData(documentToDelete document: Document) {
		let managedObjectContext = DataManager.shared.viewContext
		
		managedObjectContext.delete(document)
		
		do {
			try managedObjectContext.save()
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
}
