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
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapButton(printingState: PrintingState)
	}
	
	enum PrintingState {
		case connecting
		case printingProgress
		case printingDone
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	var printingState: PrintingState = .printingDone {
		didSet {
			configurePrintingState(printingState)
		}
	}
	
	// MARK: - View Components
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .largeTitle)
		label.numberOfLines = 1
		label.textColor = .label
		
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .body)
		label.numberOfLines = 2
		label.textAlignment = .center
		label.textColor = .label
		
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
	
	private lazy var actionButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.layer.cornerRadius = 16.0
		button.clipsToBounds = true
		button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
		
		return button
	}()
	
	// MARK: - Life Cycles
	
	override func setViews() {
		super.setViews()
		
		configureView()
	}
	
	// MARK: - Private Methods
	
	private func configurePrintingState(_ state: PrintingState) {
		switch state {
		case .connecting:
			configureNegativeButton()
			titleLabel.text = "Connecting..."
			descriptionLabel.text = "Please wait while your iPhone is connecting to the Braille Printer"
		case .printingProgress:
			configureNegativeButton()
			titleLabel.text = "Printing..."
			descriptionLabel.text = "Braille Printer is priting your document"
		case .printingDone:
			configurePositiveButton()
			titleLabel.text = "Done"
			descriptionLabel.text = "Your document has been successfully printed"
		}
	}
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [titleLabel, descriptionLabel, printerImageView, activityIndicator, actionButton])
		
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
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			actionButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
			actionButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
			actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
			actionButton.heightAnchor.constraint(equalToConstant: 48)
		])
		
		configurePrintingState(printingState)
	}
	
	private func configurePositiveButton() {
		actionButton.setBackgroundColor(.systemBlue, for: .normal)
		actionButton.setBackgroundColor(.systemGray2, for: .highlighted)
		actionButton.setTitleColor(.white, for: .normal)
		actionButton.setTitleColor(.white, for: .highlighted)
		actionButton.setTitle("Done", for: .normal)
	}
	
	private func configureNegativeButton() {
		actionButton.setBackgroundColor(.clear, for: .normal)
		actionButton.setBackgroundColor(.clear, for: .highlighted)
		actionButton.setTitleColor(.systemRed, for: .normal)
		actionButton.setTitleColor(.systemGray2, for: .highlighted)
		actionButton.setTitle("Cancel", for: .normal)
	}
	
}

extension PrintingView {
	
	// MARK: - @Objc Target
	
	@objc func actionButtonTapped() {
		onViewEvent?(.didTapButton(printingState: printingState))
	}
}
