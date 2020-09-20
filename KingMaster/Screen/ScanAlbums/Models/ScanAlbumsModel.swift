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
		case insertData
		case deleteData
		case updateData
		case moveData
	}
	
	var onModelEvent: ((ModelEvent) -> Void)?
	
	// MARK: - Private Properties
	
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
}

extension ScanAlbumsModel: NSFetchedResultsControllerDelegate {
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
	}
}
