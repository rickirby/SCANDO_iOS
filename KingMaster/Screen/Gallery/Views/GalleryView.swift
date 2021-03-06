//
//  GalleryView.swift
//  KingMaster
//
//  Created by Ricki Private on 17/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class GalleryView: UIView {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapEdit
		case didTapDownload
		case didTapDelete
		case didTapTranslate
		#if SANDBOX
		case didTapDev
		#endif
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	// MARK: - View Component
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.color = .gray
		activityIndicator.hidesWhenStopped = true
		
		return activityIndicator
	}()
	
	lazy var editBarButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editBarButtonTapped))
	
	lazy var downloadBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
	
	lazy var deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
	
	lazy var translateBarButton = UIBarButtonItem(image: UIImage(systemName: "doc.text.viewfinder"), style: .plain, target: self, action: #selector(translateBarButtonTapped))
	
	#if SANDBOX
	lazy var devBarButton = UIBarButtonItem(title: "DEV", style: .plain, target: self, action: #selector(devBarButtonTapped))
	#endif
	
	// MARK: - Life Cycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setViews() {
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
	
	func showSaveAlert(on vc: UIViewController, error: Error?) {
		AlertView.createSaveImageAlert(vc, didFinishSavingWithError: error)
	}
	
	func showDeleteAlert(on vc: UIViewController, deleteHandler: @escaping () -> Void, cancelHandler: @escaping () -> Void) {
		AlertView.createGalleryDeleteAlert(vc, deleteHandler: deleteHandler, cancelHandler: cancelHandler)
	}
}

extension GalleryView {
	
	// MARK: - @Objc Target
	
	@objc func editBarButtonTapped() {
		onViewEvent?(.didTapEdit)
	}
	
	@objc func downloadBarButtonTapped() {
		onViewEvent?(.didTapDownload)
	}
	
	@objc func deleteBarButtonTapped() {
		onViewEvent?(.didTapDelete)
	}
	
	@objc func translateBarButtonTapped() {
		onViewEvent?(.didTapTranslate)
	}
	
	#if SANDBOX
	@objc func devBarButtonTapped() {
		onViewEvent?(.didTapDev)
	}
	#endif
}
