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
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapPrint
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	// MARK: - View Components
	
	lazy var resultTextView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
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
	
	// MARK: - Public Method
	
	func startLoading() {
		ThreadManager.executeOnMain {
			self.activityIndicator.startAnimating()
		}
	}
	
	func stopLoading() {
		ThreadManager.executeOnMain {
			self.activityIndicator.stopAnimating()
		}
	}
	
	// MARK: - Private Methods
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [resultTextView, activityIndicator])
		
		NSLayoutConstraint.activate([
			resultTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
			resultTextView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5),
			resultTextView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
			resultTextView.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
	
}

extension TranslationView {
	
	// MARK: - @Objc Target
	
	@objc private func printBarButtonTapped() {
		onViewEvent?(.didTapPrint)		
	}
	
}
