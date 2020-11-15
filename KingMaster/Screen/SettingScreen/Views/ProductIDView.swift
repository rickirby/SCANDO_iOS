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
		case didTapDone
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
		label.font = .preferredFont(forTextStyle: .title3)
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
		
		return button
	}()
	
	@objc func positiveButtonTapped() {
		onViewEvent?(.didTapDone)
	}
}
