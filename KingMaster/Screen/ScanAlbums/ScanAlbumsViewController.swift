//
//  ScanAlbumsViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class ScanAlbumsViewController: ViewController<ScanAlbumsView> {
	
	// MARK: - Public Properties
	
	enum NavigationEvent {
		case didTapCamera
		case didTapPicker
		case didSelectRow(index: Int)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	// MARK: - Only for Mocking, Remove then
	var dummyData = ["Cell 0", "Cell 1", "Cell 2", "Cell 3", "Cell 4"]
	
	// MARK: - Private Properties
	
	let model = ScanAlbumsModel()
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
		screenView.reloadData(tableData: dummyData)
	}
	
	// MARK: - Private Method
	
	private func configureLoadBar() {
		title = "Scan Albums"
		navigationItem.rightBarButtonItems = [screenView.cameraBarButton, screenView.fileBarButton]
		toolbarItems = [screenView.deleteBarButton]
	}
	
	private func configureBar() {
		setLargeTitleDisplayMode(.always)
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: ScanAlbumsView.ViewEvent) in
			switch viewEvent {
			case .didTapCamera:
				self?.onNavigationEvent?(.didTapCamera)
			case .didTapPicker:
				self?.onNavigationEvent?(.didTapPicker)
			case .didSelectRow(let index):
				self?.onNavigationEvent?(.didSelectRow(index: index))
			case .editingStart:
				self?.configureNavigationItemForEditingState()
				print("EDITING")
			case .editingEnd:
				self?.configureNavigationItemForNormalState()
			case .selectAll:
				print("Select All")
			case .delete(let indexes):
				self?.deleteData(indexes: indexes)
			}
		}
	}
	
	private func configureNavigationItemForEditingState() {
		navigationItem.leftBarButtonItem = screenView.cancelBarButton
		navigationItem.rightBarButtonItems = [screenView.selectAllBarButton]
		
		navigationController?.setToolbarHidden(false, animated: true)
	}
	
	private func configureNavigationItemForNormalState() {
		navigationItem.leftBarButtonItem = nil
		navigationItem.rightBarButtonItems = [screenView.cameraBarButton, screenView.fileBarButton]
		
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	private func deleteData(indexes: [Int]) {
		var itemsToDelete = [String]()
		for i in indexes {
			itemsToDelete.append(dummyData[i])
		}
		
		for item in itemsToDelete {
			if let index = dummyData.firstIndex(of: item) {
				dummyData.remove(at: index)
			}
		}
		
		screenView.reloadData(tableData: dummyData)
	}
}
