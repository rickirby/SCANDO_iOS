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
	
	lazy var titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .preferredFont(forTextStyle: .body)
		label.textColor = .label
		label.text = "Translation Result"
		
		return label
	}()
	
	lazy var resultTextView: UITextView = {
		let textView = UITextView()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.layer.borderWidth = 1.0
		textView.layer.borderColor = UIColor.gray.cgColor
		textView.layer.cornerRadius = 3.0
		
		return textView
	}()
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .gray
		activityIndicator.hidesWhenStopped = true
		
		return activityIndicator
	}()
	
	
}
