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
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapDone
		case didTapRotateLeft
		case didTapRotateRight
		case didTapDownload
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
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
	
	lazy var filterBarButton = UIBarButtonItem(image: UIImage(named: "FilterButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(filterBarButtonTapped))
	
	// MARK: - Life Cycle
	
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
	
	func reloadImage(withImage image: UIImage) {
		previewImageView.image = image
		stopLoading()
	}
	
	func showSaveAlert(error: Error?) {
		guard let vc = findViewController() else { return }
		
		AlertView.createSaveImageAlert(vc, isOriginalImage: false, didFinishSavingWithError: error)
	}
	
	// MARK: - Private Methods
	
	func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [previewImageView, activityIndicator])
		
		NSLayoutConstraint.activate([
			previewImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
			previewImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
			previewImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
			previewImageView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
}

extension PreviewView {
	
	// MARK: - @Objc Target
	
	@objc func doneBarButtonTapped() {
		onViewEvent?(.didTapDone)
	}
	
	@objc func downloadBarButtonTapped() {
		onViewEvent?(.didTapDownload)
	}
	
	@objc func rotateRightBarButtonTapped() {
		onViewEvent?(.didTapRotateRight)
	}
	
	@objc func rotateLeftBarButtonTapped() {
		onViewEvent?(.didTapRotateLeft)
	}
	
	@objc func filterBarButtonTapped() {
	}
	
}
