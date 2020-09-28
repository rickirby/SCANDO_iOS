//
//  ScanAlbumsTableViewCell.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBCameraDocScan

class ScanAlbumsTableViewCell: UITableViewCell {
	
	// MARK: - Private Properties
	
	private lazy var previewImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		return imageView
	}()
	
	private lazy var documentLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .headline)
		label.textColor = .label
		
		return label
	}()
	
	private lazy var dateLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .subheadline)
		label.textColor = .secondaryLabel
		
		return label
	}()
	
	private lazy var numberLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .footnote)
		label.textColor = .tertiaryLabel
		
		return label
	}()
	
	// MARK: - Life Cycle
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		configureView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Private Method
	
	private func configureView() {
		backgroundColor = .systemBackground
		accessoryType = .disclosureIndicator
		
		contentView.addAllSubviews(views: [previewImageView, documentLabel, dateLabel, numberLabel])
		
		NSLayoutConstraint.activate([
			previewImageView.heightAnchor.constraint(equalToConstant: 64),
			previewImageView.widthAnchor.constraint(equalToConstant: 64),
			previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			previewImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
			
			documentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
			documentLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 20),
			
			dateLabel.topAnchor.constraint(equalTo: documentLabel.bottomAnchor, constant: 3),
			dateLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 20),
			
			numberLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 3),
			numberLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 20),
			numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
		])
	}
	
	private func generateThumbnail(from object: DocumentGroup) {
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			
			guard let documents = object.documents.allObjects as? [Document] else { return }
			let sortedDocument = documents.sorted {
				$0.date.compare($1.date) == .orderedAscending
			}
			var thumbnailImage = #imageLiteral(resourceName: "ICON")
			if let lastDocument = sortedDocument.last, let thumbnail = UIImage(data: lastDocument.thumbnail) {
				thumbnailImage = thumbnail
			}
			
			ThreadManager.executeOnMain {
				self?.previewImageView.stopShimmering()
				self?.previewImageView.image = thumbnailImage
			}
		}
		
	}
	
	// MARK: - Public Method
	
	func configure(with object: DocumentGroup) {
		documentLabel.text = object.name
		dateLabel.text = SCANDODateFormatter.shared.string(from: object.date)
		numberLabel.text = "\(object.documents.count) " + (object.documents.count > 1 ? "pages" : "page")
		previewImageView.startShimmering()
		generateThumbnail(from: object)
	}
}
