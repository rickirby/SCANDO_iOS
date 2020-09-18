//
//  PreviewView.swift
//  KingMaster
//
//  Created by Ricki Private on 18/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class PreviewView: View {
	
	// MARK: - View Components
	
	lazy var previewImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .white
		activityIndicator.hidesWhenStopped = true
		
		return activityIndicator
	}()
	
	lazy var doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBarButtonTapped))
	
	lazy var downloadBarButton = UIBarButtonItem(image: UIImage(named: "SaveButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
	
	lazy var rotateRightBarButton = UIBarButtonItem(image: UIImage(named: "RotateRightButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(rotateRightBarButtonTapped))
	
	lazy var rotateLeftBarButton = UIBarButtonItem(image: UIImage(named: "RotateLeftButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(rotateLeftBarButtonTapped))
	
	lazy var translateBarButton = UIBarButtonItem(image: UIImage(named: "FilterButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(translateBarButtonTapped))
}

extension PreviewView {
	
	// MARK: - @Objc Target
	
	@objc func doneBarButtonTapped() {
		
	}
	
	@objc func downloadBarButtonTapped() {
		
	}
	
	@objc func rotateRightBarButtonTapped() {
		
	}
	
	@objc func rotateLeftBarButtonTapped() {
		
	}
	
	@objc func translateBarButtonTapped() {
		
	}
	
}
