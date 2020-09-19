//
//  DocumentGroup+CoreDataProperties.swift
//  KingMaster
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//
//

import Foundation
import CoreData


extension DocumentGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentGroup> {
        return NSFetchRequest<DocumentGroup>(entityName: "DocumentGroup")
    }

    @NSManaged public var date: Date
    @NSManaged public var name: String
    @NSManaged public var documents: NSSet

}

// MARK: Generated accessors for documents
extension DocumentGroup {

    @objc(addDocumentsObject:)
    @NSManaged public func addToDocuments(_ value: Document)

    @objc(removeDocumentsObject:)
    @NSManaged public func removeFromDocuments(_ value: Document)

    @objc(addDocuments:)
    @NSManaged public func addToDocuments(_ values: NSSet)

    @objc(removeDocuments:)
    @NSManaged public func removeFromDocuments(_ values: NSSet)

}
