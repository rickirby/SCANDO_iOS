//
//  GalleryViewController.swift
//  KingMaster
//
//  Created by Afni Laili on 12/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBPhotosGallery

class GalleryViewController: RBPhotosGalleryViewController {
	
	var dummyData: [UIImage] = [#imageLiteral(resourceName: "ICON"), #imageLiteral(resourceName: "ICON"), #imageLiteral(resourceName: "ICON")]
	
	// MARK: - Private Properties
	
	private var screenView = GalleryView()
	
	// MARK: - Life Cycle
	
	public override func loadView() {
		super.loadView()
		view.addSubview(screenView)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
	}
	
	// MARK: - Private Methods
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.rightBarButtonItem = screenView.editBarButton
		toolbarItems = [screenView.deleteBarButton, spacer, screenView.downloadBarButton]
	}
	
	private func configureBar() {
		setLargeTitleDisplayMode(.never)
		navigationController?.interactivePopGestureRecognizer?.isEnabled = true
		navigationController?.setToolbarHidden(false, animated: true)
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: GalleryView.ViewEvent) in
			switch viewEvent {
			case .didTapEdit:
				print("Tap Edit")
			case .didTapDownload:
				print("Tap Download")
			case .didTapDelete:
				print("Tap Delete")
			}
		}
	}
}

extension GalleryViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return dummyData
	}
}
