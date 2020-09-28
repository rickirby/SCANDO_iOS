//
//  Document+CoreDataProperties.swift
//  KingMaster
//
//  Created by Ricki Private on 21/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//
//

import Foundation
import CoreData


extension Document {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Document> {
        return NSFetchRequest<Document>(entityName: "Document")
    }

    @NSManaged public var date: Date
    @NSManaged public var rotationAngle: Double
    @NSManaged public var thumbnail: Data
    @NSManaged public var image: DocumentImage
    @NSManaged public var owner: DocumentGroup?
    @NSManaged public var quad: QuadPoint

}
