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
		label.font = .systemFont(ofSize: 36, weight: .bold)
		label.numberOfLines = 1
		label.textColor = .label
		label.text = "Default Title"
		
		return label
	}()
	
	private lazy var descriptionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 18, weight: .regular)
		label.textColor = .label
		label.text = "Default description for this view"
		
		return label
	}()
	
	private lazy var printerImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.image = UIImage(named: "Printer")
		
		return imageView
	}()
	
	private lazy var positiveButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .systemBlue
		button.setTitleColor(.white, for: .normal)
		button.layer.cornerRadius = 16.0
		
		return button
	}()
	
	private lazy var negativeButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.backgroundColor = .clear
		button.setTitleColor(.systemRed, for: .normal)
		button.layer.borderColor = UIColor.systemRed.cgColor
		button.layer.borderWidth = 1.0
		button.layer.cornerRadius = 16.0
		
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
	
	// MARK: - Private Methods
	
	private func configureView() {
		addAllSubviews(views: [titleLabel, descriptionLabel, printerImageView, verticalStack])
		configureVerticalStack()
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 90),
			titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 21),
			descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			
			printerImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 90),
			printerImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			printerImageView.widthAnchor.constraint(equalToConstant: CGFloat(214.0).makeDynamicW()),
			printerImageView.heightAnchor.constraint(equalToConstant: CGFloat(214.0).makeDynamicW()),
			
			verticalStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24),
			verticalStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -24),
			verticalStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -68),
			
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
	
}
