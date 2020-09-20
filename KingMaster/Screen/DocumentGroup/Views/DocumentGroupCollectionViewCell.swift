//
//  DocumentGroupCollectionViewCell.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBCameraDocScan

class DocumentGroupCollectionViewCell: UICollectionViewCell {
	
	// MARK: - Private Properties
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.backgroundColor = .secondarySystemFill
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		return imageView
	}()
	
	// MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Private Method
	
	private func configureView() {
		addAllSubviews(views: [imageView])
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
			imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
			imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
		])
	}
	
	// MARK: - Public Method
	
	func configure(with object: Document) {
		imageView.startShimmering()
		
		DispatchQueue.global(qos: .userInitiated).async {
			guard let originalImage = UIImage(data: object.image.originalImage) else { return }
			
			let quad = Quadrilateral(topLeft: CGPoint(x: object.quad.topLeftX, y: object.quad.topLeftY), topRight: CGPoint(x: object.quad.topRightX, y: object.quad.topRightY), bottomRight: CGPoint(x: object.quad.bottomRightX, y: object.quad.bottomRightY), bottomLeft: CGPoint(x: object.quad.bottomLeftX, y: object.quad.bottomLeftY))
			
			let processedImage = PerspectiveTransformer.applyTransform(to: originalImage, withQuad: quad).rotated(by: Measurement<UnitAngle>(value: object.rotationAngle, unit: .degrees))
			
			ThreadManager.executeOnMain {
				self.imageView.stopShimmering()
				self.imageView.image = processedImage
			}
		}
	}
}
