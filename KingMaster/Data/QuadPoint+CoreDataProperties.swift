//
//  QuadPoint+CoreDataProperties.swift
//  KingMaster
//
//  Created by Ricki Private on 19/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//
//

import Foundation
import CoreData


extension QuadPoint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<QuadPoint> {
        return NSFetchRequest<QuadPoint>(entityName: "QuadPoint")
    }

    @NSManaged public var topLeftX: Double
    @NSManaged public var topLeftY: Double
    @NSManaged public var topRightX: Double
    @NSManaged public var topRightY: Double
    @NSManaged public var bottomLeftX: Double
    @NSManaged public var bottomLeftY: Double
    @NSManaged public var bottomRightX: Double
    @NSManaged public var bottomRightY: Double
    @NSManaged public var owner: Document?

}
