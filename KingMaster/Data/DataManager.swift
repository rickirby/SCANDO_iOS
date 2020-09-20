//
//  DataManager.swift
//  KingMaster
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import CoreData

class DataManager {
	
	// MARK: - Public Properties
	
	static let shared: DataManager = DataManager()
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "KingMaster")
		container.loadPersistentStores { (_, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		
		return container
	}()
	
	func saveContext() {
        let context = DataManager.shared.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
