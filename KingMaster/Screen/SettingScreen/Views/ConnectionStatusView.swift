//
//  ConnectionStatusView.swift
//  Production
//
//  Created by Ricki Private on 08/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class ConnectionStatusView: View {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapPositive
		case didTapNegative
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	// MARK: - Private Properties
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .largeTitle)
		label.numberOfLines = 1
		label.textColor = .label
		label.text = "Hi, there!"
		
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .body)
		label.numberOfLines = 2
		label.textAlignment = .center
		label.textColor = .label
		label.text = "If you have supported Braille Printer, you can pair it with your iPhone here"
		
		return label
	}()
	
	private lazy var learnMoreButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(.systemBlue, for: .normal)
		button.setTitleColor(.systemGray2, for: .highlighted)
		button.setTitle("Learn More about Braille Printer", for: .normal)
		
		return button
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
	
	private lazy var positiveButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setBackgroundColor(.systemBlue, for: .normal)
		button.setBackgroundColor(.systemGray2, for: .highlighted)
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 16.0
		button.clipsToBounds = true
		button.addTarget(self, action: #selector(positiveButtonTapped), for: .touchUpInside)
		button.setTitle("Start Pairing", for: .normal)
		
		return button
	}()
	
	private lazy var negativeButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(.systemRed, for: .normal)
		button.setTitleColor(.systemGray2, for: .highlighted)
		button.addTarget(self, action: #selector(negativeButtonTapped), for: .touchUpInside)
		button.setTitle("Cancel", for: .normal)
		
		return button
	}()
	
	private lazy var verticalStack: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.distribution = .equalCentering
		stackView.spacing = 14.0
		
		return stackView
	}()
	
	// MARK: - Life Cycles
	
	override func setViews() {
		configureView()
	}
	
	// MARK: - Public Methods
	
	func configureStatus(for status: ConnectionStatusViewController.Status, sharedSSID: String? = nil) {
		
		switch status {
		
		case .directConnected:
			titleLabel.text = SCANDOConstant.connectionStatusTitleConnected
			descriptionLabel.text = SCANDOConstant.connectionStatusDescriptionConnected
			positiveButton.setTitle(SCANDOConstant.connectionStatusPositiveButtonConnected, for: .normal)
			negativeButton.setTitle(SCANDOConstant.connectionStatusNegativeButtonConnected, for: .normal)
			
		case .sharedConnected:
			titleLabel.text = SCANDOConstant.connectionStatusTitleSharedConnected
			descriptionLabel.text = SCANDOConstant.connectionStatusDescriptionSharedConnected
			positiveButton.setTitle(SCANDOConstant.connectionStatusPositiveButtonSharedConnected, for: .normal)
			negativeButton.setTitle(SCANDOConstant.connectionStatusNegativeButtonSharedConnected, for: .normal)
		
		case .disconnected:
			titleLabel.text = SCANDOConstant.connectionStatusTitleDisconnected
			descriptionLabel.text = SCANDOConstant.connectionStatusDescriptionDisconnected
			positiveButton.setTitle(SCANDOConstant.connectionStatusPositiveButtonDisconnected, for: .normal)
			negativeButton.setTitle(SCANDOConstant.connectionStatusNegativeButtonDisconnected, for: .normal)
		
		case .differentNetwork:
			titleLabel.text = SCANDOConstant.connectionStatusTitleDifferentNetwork
			descriptionLabel.text = SCANDOConstant.connectionStatusDescriptionDifferentNetwork
			positiveButton.setTitle(SCANDOConstant.connectionStatusPositiveButtonDifferentNetwork, for: .normal)
			negativeButton.setTitle(SCANDOConstant.connectionStatusNegativeButtonDifferentNetwork, for: .normal)
		}
		
	}

	func startLoading() {
		activityIndicator.startAnimating()
	}
	
	func stopLoading() {
		activityIndicator.stopAnimating()
	}
	
	// MARK: - Private Methods
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [titleLabel, descriptionLabel, learnMoreButton, printerImageView, activityIndicator, verticalStack])
		configureVerticalStack()
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 90),
			titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 21),
			descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
			descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
			
			learnMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 21),
			learnMoreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			printerImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 90),
			printerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			printerImageView.widthAnchor.constraint(equalToConstant: CGFloat(214.0).makeDynamicW()),
			printerImageView.heightAnchor.constraint(equalToConstant: CGFloat(214.0).makeDynamicW()),
			
			activityIndicator.topAnchor.constraint(equalTo: printerImageView.bottomAnchor, constant: 20),
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			verticalStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
			verticalStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
			verticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40),
			
			positiveButton.widthAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 1),
			positiveButton.heightAnchor.constraint(equalToConstant: 48),
			
			negativeButton.widthAnchor.constraint(equalTo: verticalStack.widthAnchor, multiplier: 1),
			negativeButton.heightAnchor.constraint(equalToConstant: 48)
		])
	}
	
	private func configureVerticalStack() {
		let views = [positiveButton, negativeButton]
		
		for view in views {
			verticalStack.addArrangedSubview(view)
		}
	}
	
	@objc func positiveButtonTapped() {
		onViewEvent?(.didTapPositive)
	}
	
	@objc func negativeButtonTapped() {
		onViewEvent?(.didTapNegative)
	}
	
}
