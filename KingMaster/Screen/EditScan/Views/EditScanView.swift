//
//  EditScanView.swift
//  KingMaster
//
//  Created by Ricki Private on 17/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBCameraDocScan

class EditScanView: View {
	
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
		activityIndicator.color = .white
		activityIndicator.hidesWhenStopped = true
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()
	
	// MARK: - Life Cycle
	
	override func setViews() {
		super.setViews()
	}
}
