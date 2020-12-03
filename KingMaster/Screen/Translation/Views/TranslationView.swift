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
	
	// MARK: - View Components
	
	lazy var resultTextView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.layer.borderWidth = 1.0
		textView.layer.borderColor = UIColor.gray.cgColor
		textView.layer.cornerRadius = 3.0
		textView.font = .preferredFont(forTextStyle: .body)
		textView.addDoneButtonOnKeyboard()
		
		return textView
	}()
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .gray
		activityIndicator.hidesWhenStopped = true
		
		return activityIndicator
	}()
	
	lazy var printBarButton: UIBarButtonItem = UIBarButtonItem(title: "Print", style: .plain, target: self, action: #selector(printBarButtonTapped))
	
	// MARK: - Life Cycles
	
	override func setViews() {
		super.setViews()
		
		configureView()
	}
	
	// MARK: - Private Methods
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [resultTextView, activityIndicator])
		
		NSLayoutConstraint.activate([
			resultTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
			resultTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
			resultTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
			resultTextView.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor, constant: -40)
		])
	}
	
	@objc private func printBarButtonTapped() {
		
	}
}
