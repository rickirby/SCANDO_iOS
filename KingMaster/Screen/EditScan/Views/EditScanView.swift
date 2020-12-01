//
//  EditScanView.swift
//  KingMaster
//
//  Created by Ricki Private on 17/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import AVFoundation
import RBToolkit
import RBCameraDocScan

class EditScanView: View {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapNext
		case didTapAll
		case didTapDownload
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	var image: UIImage? {
		didSet {
			capturedImageView.image = image
		}
	}
	
	// MARK: - View Components
	
	var quadViewWidthConstraint = NSLayoutConstraint()
	var quadViewHeightConstraint = NSLayoutConstraint()
	
	lazy var capturedImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.clipsToBounds = true
		imageView.isOpaque = true
		imageView.backgroundColor = .systemBackground
		imageView.contentMode = .scaleAspectFit
		
		return imageView
	}()
	
	lazy var quadView: QuadrilateralView = {
		let quadView = QuadrilateralView()
		quadView.editable = true
		quadView.translatesAutoresizingMaskIntoConstraints = false
		return quadView
	}()
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.color = .gray
		activityIndicator.hidesWhenStopped = true
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()
	
	lazy var nextBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextBarButtonTapped))
	
	lazy var allAreaBarButton = UIBarButtonItem(image: UIImage(named: "AllButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(allAreaBarButtonTapped))
	
	lazy var downloadBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
	
	// MARK: - Life Cycle
	
	override func setViews() {
		super.setViews()
		
		configureView()
	}
	
	override func onViewDidDisappear() {
		super.onViewDidDisappear()
		
		stopLoading()
	}
	
	override func onViewDidLayoutSubviews() {
		super.onViewDidLayoutSubviews()
		
		adjustQuadViewConstraints()
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
	
	func showSaveAlert(error: Error?) {
		guard let vc = findViewController() else { return }
		
		AlertView.createSaveImageAlert(vc, didFinishSavingWithError: error)
	}
	
	// MARK: - Private Method
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [capturedImageView, quadView, activityIndicator])
		
		quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
		quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
		
		NSLayoutConstraint.activate([
			capturedImageView.topAnchor.constraint(equalTo: self.topAnchor),
			capturedImageView.leftAnchor.constraint(equalTo: self.leftAnchor),
			capturedImageView.rightAnchor.constraint(equalTo: self.rightAnchor),
			capturedImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			
			quadView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			quadView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			quadViewWidthConstraint,
			quadViewHeightConstraint,
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
		])
	}
	
	private func adjustQuadViewConstraints() {
		guard let image = image else { return }
		let frame = AVMakeRect(aspectRatio: image.size, insideRect: capturedImageView.bounds)
		quadViewWidthConstraint.constant = frame.size.width
		quadViewHeightConstraint.constant = frame.size.height
	}
	
}

extension EditScanView {
	
	// MARK: - @Objc Target
	
	@objc func nextBarButtonTapped() {
		onViewEvent?(.didTapNext)
	}
	
	@objc func allAreaBarButtonTapped() {
		onViewEvent?(.didTapAll)
	}
	
	@objc func downloadBarButtonTapped() {
		onViewEvent?(.didTapDownload)
	}
}
