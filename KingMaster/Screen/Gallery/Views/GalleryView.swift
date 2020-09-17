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
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	// MARK: - View Component
	
	lazy var editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editBarButtonTapped))
	
	lazy var downloadBarButton = UIBarButtonItem(image: UIImage(named: "SaveButton")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(downloadBarButtonTapped))
	
	lazy var deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setViews() {
		
	}
}

extension GalleryView {
	
	// MARK: - @Objc Target
	
	@objc func editBarButtonTapped() {
		
	}
	
	@objc func downloadBarButtonTapped() {
		
	}
	
	@objc func deleteBarButtonTapped() {
		
	}
}
