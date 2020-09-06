//
//  ScanAlbumsTableViewCell.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

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
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Private Method
	
	func configureView() {
		backgroundColor = .systemBackground
		accessoryType = .disclosureIndicator
		
		contentView.addAllSubviews(views: [previewImageView, documentLabel, dateLabel, numberLabel])
		
		NSLayoutConstraint.activate([
			documentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(13).makeDynamicH()),
			documentLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: CGFloat(20).makeDynamicW()),
			
			dateLabel.topAnchor.constraint(equalTo: documentLabel.bottomAnchor, constant: CGFloat(5).makeDynamicH()),
			dateLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: CGFloat(20).makeDynamicW()),
			
			numberLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: CGFloat(5).makeDynamicH()),
			numberLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: CGFloat(20).makeDynamicW()),
			numberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: CGFloat(-13).makeDynamicH()),
			
			previewImageView.heightAnchor.constraint(equalToConstant: CGFloat(83).makeDynamicW() < 83 ? CGFloat(83).makeDynamicW() : 87),
			previewImageView.widthAnchor.constraint(equalToConstant: CGFloat(83).makeDynamicW() < 83 ? CGFloat(83).makeDynamicW() : 87),
			previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			previewImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor)
		])
	}
}
