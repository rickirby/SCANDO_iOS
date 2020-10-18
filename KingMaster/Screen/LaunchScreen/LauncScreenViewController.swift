//
//  LauncScreenViewController.swift
//  Production
//
//  Created by Ricki Private on 18/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
	
	// MARK: - Private Properties
	
	lazy var iconImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.image = UIImage(named: "ICON")
		
		return imageView
	}()
	
	lazy var scandoLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 26, weight: .semibold)
		label.textColor = .white
		label.text = "SCANDO"
		
		return label
	}()
	
	lazy var versionLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 12, weight: .regular)
		label.textColor = .white
		if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
			label.text = "version \(version).\(buildNumber)"
		}
		
		return label
	}()
	
	override func loadView() {
		super.loadView()
		
		view.addAllSubviews(views: [iconImageView, scandoLabel, versionLabel])
		
		NSLayoutConstraint.activate([
			iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			iconImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 230/414),
			iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
			
			scandoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			scandoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -138),
			
			versionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			versionLabel.topAnchor.constraint(equalTo: scandoLabel.bottomAnchor, constant: 5)
		])
	}
}
