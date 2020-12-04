//
//  PrintingView.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 04/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class PrintingView: View {
	
	// MARK: - View Components
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .largeTitle)
		label.numberOfLines = 1
		label.textColor = .label
		label.text = "Connecting..."
		
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .body)
		label.numberOfLines = 2
		label.textAlignment = .center
		label.textColor = .label
		label.text = "Please wait while iPhone is connecting to the Braille Printer"
		
		return label
	}()
	
	private lazy var printerImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(named: "Printer")
		
		return imageView
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .gray
		activityIndicator.hidesWhenStopped = true
		activityIndicator.stopAnimating()
		
		return activityIndicator
	}()
	
	// MARK: - Life Cycles
	
	override func setViews() {
		super.setViews()
		
		configureView()
	}
	
	// MARK: - Private Methods
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [titleLabel, descriptionLabel, printerImageView, activityIndicator])
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 90),
			titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 21),
			descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
			descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
			
			printerImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 90),
			printerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			printerImageView.widthAnchor.constraint(equalToConstant: CGFloat(214.0).makeDynamicW()),
			printerImageView.heightAnchor.constraint(equalToConstant: CGFloat(214.0).makeDynamicW()),
			
			activityIndicator.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: 20),
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		])
	}
}
