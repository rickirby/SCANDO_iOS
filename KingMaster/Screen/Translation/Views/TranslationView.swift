//
//  TranslationView.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 01/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class TranslationView: View {
	
	// MARK: - Private Properties
	
	private lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .body)
		label.textColor = .label
		label.text = "Translation Result"
		
		return label
	}()
	
	private lazy var resultTextView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.layer.borderWidth = 1.0
		textView.layer.borderColor = UIColor.gray.cgColor
		textView.layer.cornerRadius = 3.0
		textView.addDoneButtonOnKeyboard()
		
		return textView
	}()
	
	private lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .gray
		activityIndicator.hidesWhenStopped = true
		
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
		addAllSubviews(views: [titleLabel, resultTextView, activityIndicator])
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
			titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
			titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
			
			resultTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
			resultTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
			resultTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
			resultTextView.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor, constant: -40)
		])
	}
	
}
