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
			guard let thumbnailImage = UIImage(data: object.thumbnail) else { return }
			
			ThreadManager.executeOnMain {
				self.imageView.stopShimmering()
				self.imageView.image = thumbnailImage
			}
		}
	}
}
