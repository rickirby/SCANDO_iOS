//
//  DocumentImage+CoreDataProperties.swift
//  KingMaster
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//
//

import Foundation
import CoreData


extension DocumentImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DocumentImage> {
        return NSFetchRequest<DocumentImage>(entityName: "DocumentImage")
    }

    @NSManaged public var originalImage: Data?
    @NSManaged public var owner: Document?

}
