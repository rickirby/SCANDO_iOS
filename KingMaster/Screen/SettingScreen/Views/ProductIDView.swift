//
//  ProductIDView.swift
//  Production
//
//  Created by Ricki Private on 10/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class ProductIDView: View {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapDone(productID: String)
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	// MARK: - Private Properties
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .largeTitle)
		label.numberOfLines = 1
		label.textColor = .label
		label.text = "Product ID"
		
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .body)
		label.numberOfLines = 2
		label.textAlignment = .center
		label.textColor = .label
		label.text = "The Product ID is 6 keys containing alphabets and numbers, located on your printer body"
		
		return label
	}()
	
	private lazy var learnMoreButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitleColor(.systemBlue, for: .normal)
		button.setTitleColor(.systemGray2, for: .highlighted)
		button.setTitle("Learn More about Product ID", for: .normal)
		
		return button
	}()
	
	private lazy var productIDTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = .systemGray6
		textField.layer.cornerRadius = 12.0
		textField.layer.borderWidth = 1.0
		textField.layer.borderColor = UIColor.systemGray3.cgColor
		textField.clipsToBounds = true
		textField.textAlignment = .center
		textField.font = .preferredFont(forTextStyle: .title2)
		textField.placeholder = "Input Product ID here"
		textField.keyboardType = .numberPad
		textField.addDoneButtonOnKeyboard()
		textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
		
		return textField
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
		button.isEnabled = false
		
		return button
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
	
	// MARK: - Public Methods
	
	func startLoading() {
		activityIndicator.startAnimating()
	}
	
	func stopLoading() {
		activityIndicator.stopAnimating()
	}
	
	// MARK: - Private Methods
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [titleLabel, descriptionLabel, learnMoreButton, productIDTextField, positiveButton, activityIndicator])
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 90),
			titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 21),
			descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
			descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30),
			
			learnMoreButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 21),
			learnMoreButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			productIDTextField.topAnchor.constraint(equalTo: learnMoreButton.bottomAnchor, constant: 57),
			productIDTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 46),
			productIDTextField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -46),
			productIDTextField.heightAnchor.constraint(equalToConstant: 64),
			
			positiveButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
			positiveButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
			positiveButton.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor, constant: -40),
			positiveButton.heightAnchor.constraint(equalToConstant: 48),
			
			activityIndicator.topAnchor.constraint(equalTo: productIDTextField.bottomAnchor, constant: 20),
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		])
	}
	
	@objc private func positiveButtonTapped() {
		guard let productID = productIDTextField.text else {
			return
		}
		
		productIDTextField.resignFirstResponder()
		startLoading()
		onViewEvent?(.didTapDone(productID: productID))
	}
	
	@objc private func textFieldDidChanged() {
		guard let text = productIDTextField.text else {
			return
		}
		
		positiveButton.isEnabled = text.count == 6
	}
}
