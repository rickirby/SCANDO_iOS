//
//  PreviewModel.swift
//  KingMaster
//
//  Created by Ricki Private on 20/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import CoreData
import RBCameraDocScan

class PreviewModel: NSObject {
	
	override init() {
		super.init()
	}
	
	func addNewDocumentGroup(name: String, originalImage image: UIImage, thumbnailImage: UIImage, quad: Quadrilateral, rotationAngle: Double, date: Date) {
		
		let managedObjectContext = DataManager.shared.persistentContainer.viewContext
		
		let documentGroup = DocumentGroup(context: managedObjectContext)
		documentGroup.name = name
		documentGroup.date = date
		
		if let imageData = image.jpegData(compressionQuality: 0.7), let thumbnailData = thumbnailImage.jpegData(compressionQuality: 0.7) {
			let quadPoint = QuadPoint(context: managedObjectContext)
			quadPoint.topLeftX = Double(quad.topLeft.x)
			quadPoint.topLeftY = Double(quad.topLeft.y)
			quadPoint.topRightX = Double(quad.topRight.x)
			quadPoint.topRightY = Double(quad.topRight.y)
			quadPoint.bottomLeftX = Double(quad.bottomLeft.x)
			quadPoint.bottomLeftY = Double(quad.bottomLeft.y)
			quadPoint.bottomRightX = Double(quad.bottomRight.x)
			quadPoint.bottomRightY = Double(quad.bottomRight.y)
			
			let image = DocumentImage(context: managedObjectContext)
			image.originalImage = imageData
			
			let document = Document(context: managedObjectContext)
			document.image = image
			document.thumbnail = thumbnailData
			document.quad = quadPoint
			document.date = date
			document.rotationAngle = rotationAngle
			
			documentGroup.documents = NSSet.init(array: [document])
		}
		
		do {
			try managedObjectContext.save()
			print("Saving \(Date())")
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
	
	func addDocumentToDocumentGroup(documentGroup: DocumentGroup, originalImage image: UIImage, thumbnailImage: UIImage, quad: Quadrilateral, rotationAngle: Double, date: Date) {
		
		let managedObjectContext = DataManager.shared.persistentContainer.viewContext
		
		if let imageData = image.jpegData(compressionQuality: 0.7), let thumbnailData = thumbnailImage.jpegData(compressionQuality: 0.7) {
			let quadPoint = QuadPoint(context: managedObjectContext)
			quadPoint.topLeftX = Double(quad.topLeft.x)
			quadPoint.topLeftY = Double(quad.topLeft.y)
			quadPoint.topRightX = Double(quad.topRight.x)
			quadPoint.topRightY = Double(quad.topRight.y)
			quadPoint.bottomLeftX = Double(quad.bottomLeft.x)
			quadPoint.bottomLeftY = Double(quad.bottomLeft.y)
			quadPoint.bottomRightX = Double(quad.bottomRight.x)
			quadPoint.bottomRightY = Double(quad.bottomRight.y)
			
			let image = DocumentImage(context: managedObjectContext)
			image.originalImage = imageData
			
			let document = Document(context: managedObjectContext)
			document.image = image
			document.thumbnail = thumbnailData
			document.quad = quadPoint
			document.date = date
			document.rotationAngle = rotationAngle
			
			documentGroup.addToDocuments(document)
			documentGroup.date = date
		}
		
		do {
			try managedObjectContext.save()
		} catch let error as NSError {
			print("Could not save \(error), \(error.userInfo)")
		}
	}
	
	func updateDocument(documentGroup: DocumentGroup, currentDocument: Document, newQuadrilateral: Quadrilateral?, newRotationAngle: Double?, newThumbnailImage: UIImage) {
        
        let managedObjectContext = DataManager.shared.persistentContainer.viewContext
        var isChanged = false
        
        if let quad = newQuadrilateral {
            let quadPoint = QuadPoint(context: managedObjectContext)
            quadPoint.topLeftX = Double(quad.topLeft.x)
            quadPoint.topLeftY = Double(quad.topLeft.y)
            quadPoint.topRightX = Double(quad.topRight.x)
            quadPoint.topRightY = Double(quad.topRight.y)
            quadPoint.bottomLeftX = Double(quad.bottomLeft.x)
            quadPoint.bottomLeftY = Double(quad.bottomLeft.y)
            quadPoint.bottomRightX = Double(quad.bottomRight.x)
            quadPoint.bottomRightY = Double(quad.bottomRight.y)
            
            currentDocument.quad = quadPoint
            isChanged = true
        }
        
        if let rotationAngle = newRotationAngle {
            currentDocument.rotationAngle = rotationAngle
            isChanged = true
        }
        
        if isChanged {
            let date = Date()
            documentGroup.date = date
            currentDocument.date = date
			
			if let thumbnailData = newThumbnailImage.jpegData(compressionQuality: 0.7) {
				currentDocument.thumbnail = thumbnailData
			}
            
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
}
