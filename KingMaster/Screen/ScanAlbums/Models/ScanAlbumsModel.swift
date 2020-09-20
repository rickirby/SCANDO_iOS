//
//  ScanAlbumsModel.swift
//  KingMaster
//
//  Created by Ricki Private on 20/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import CoreData

class ScanAlbumsModel: NSObject {
	
	// MARK: - Public Properties
	
	enum ModelEvent {
		case beginUpdates
		case endUpdates
		case insertData(newIndexPath: IndexPath)
		case deleteData(indexPath: IndexPath)
		case updateData(indexPath: IndexPath)
		case moveData(indexPath: IndexPath, newIndexPath: IndexPath)
	}
	
	var onModelEvent: ((ModelEvent) -> Void)?
	
	lazy var fetchedResultsController: NSFetchedResultsController<DocumentGroup> = {
		let managedContext = DataManager.shared.persistentContainer.viewContext
		let fetchRequest = NSFetchRequest<DocumentGroup>(entityName: "DocumentGroup")
		let sort = NSSortDescriptor(key: "date", ascending: false)
		fetchRequest.sortDescriptors = [sort]
		
		let fetchedResultsController = NSFetchedResultsController<DocumentGroup>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
		
		return fetchedResultsController
	}()
	
	// MARK: - Life Cycle
	
	override init() {
		super.init()
		
		fetchedResultsController.delegate = self
	}
	
	// MARK: - Public Method
	
	func fetchData() {
		do {
			try fetchedResultsController.performFetch()
		} catch {
			fatalError(error.localizedDescription)
		}
	}
	
}

extension ScanAlbumsModel: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
	}
}
