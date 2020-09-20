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
		configureViewData()
		configureModel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
		model.fetchData()
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
			case .editingEnd:
				self?.configureNavigationItemForNormalState()
			case .selectAll:
				print("Select All")
			case .delete(let indexes):
				self?.deleteData(indexes: indexes)
			}
		}
	}
	
	private func configureViewData() {
		screenView.viewDataSupply = {
			guard let fetchedObjects = self.model.fetchedResultsController.fetchedObjects else {
				return []
			}
			return fetchedObjects
		}
	}
	
	private func configureModel() {
		model.onModelEvent = { (modelEvent: ScanAlbumsModel.ModelEvent) in
			switch modelEvent {
			case .beginUpdates:
				self.screenView.tableView.beginUpdates()
			case .endUpdates:
				self.screenView.tableView.endUpdates()
			case .insertData(let newIndexPath):
				self.screenView.tableView.insertRows(at: [newIndexPath], with: .fade)
			case .deleteData(let indexPath):
				self.screenView.tableView.deleteRows(at: [indexPath], with: .left)
			case .updateData(let indexPath):
				self.screenView.tableView.reloadRows(at: [indexPath], with: .fade)
			case .moveData(let indexPath, let newIndexPath):
				self.screenView.tableView.moveRow(at: indexPath, to: newIndexPath)
				self.screenView.tableView.reloadRows(at: [newIndexPath], with: .fade)
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
		
//		screenView.tableViewData = dummyData
	}
}
