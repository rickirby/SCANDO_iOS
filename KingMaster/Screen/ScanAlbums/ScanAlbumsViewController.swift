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
		case didTapSetting
		case didSelectRow(index: Int, object: DocumentGroup)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	// MARK: - Private Properties
	
	private let model = ScanAlbumsModel()
	
	private var rightBarButtonItemsNormalState: [UIBarButtonItem] {
		return [screenView.cameraBarButton]
	}
	
	private var rightBarButtonItemsEditingState: [UIBarButtonItem] {
		return [screenView.selectAllBarButton]
	}
	
	private var leftBarButtonItemsNormalState: [UIBarButtonItem] {
		return [screenView.settingBarButton]
	}
	
	private var leftBarButtonItemsEditingState: [UIBarButtonItem] {
		return [screenView.cancelBarButton]
	}
	
	// MARK: - Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		configureViewEvent()
		configureViewData()
		configureModel()
		configureObserver()
		model.fetchData()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		configureBar()
	}
	
	// MARK: - Private Method
	
	private func configureLoadBar() {
		title = "Scan Albums"
		navigationItem.rightBarButtonItems = rightBarButtonItemsNormalState
		navigationItem.leftBarButtonItems = leftBarButtonItemsNormalState
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
			case .didTapSetting:
				self?.onNavigationEvent?(.didTapSetting)
			case .didSelectRow(let index):
				guard let object = self?.model.fetchedResultsController.object(at: IndexPath(row: index, section: 0)) else { return }
				self?.onNavigationEvent?(.didSelectRow(index: index, object: object))
			case .editingStart:
				self?.configureNavigationItemForEditingState()
			case .editingEnd:
				self?.configureNavigationItemForNormalState()
			case .selectAll:
				print("Select All")
			case .delete(let indexes):
				self?.deleteData(indexes: indexes)
			case .rename(let index, let newName):
				guard let object = self?.model.fetchedResultsController.object(at: IndexPath(row: index, section: 0)), !newName.isEmpty else { return }
				self?.model.updateName(documentGroupToUpdate: object, newName: newName)
			case .saveAll(let index):
				self?.saveAllDocument(index)
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
		var indexToDelete: [Int] = []
		model.onModelEvent = { (modelEvent: ScanAlbumsModel.ModelEvent) in
			switch modelEvent {
			case .beginUpdates:
				self.screenView.tableView.beginUpdates()
			case .endUpdates:
				self.screenView.tableView.endUpdates()
			case .insertData(let newIndexPath):
				GalleryCache.slideDownAllCache()
				self.screenView.tableView.insertRows(at: [newIndexPath], with: .automatic)
			case .deleteData(let indexPath):
				if indexToDelete.isEmpty {
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
						for i in indexToDelete {
							GalleryCache.removeCache(for: i)
							GalleryCache.slideUpCache(after: i)
						}
						
						indexToDelete.removeAll()
					}
				}
				
				indexToDelete.append(indexPath.row)
				self.screenView.tableView.deleteRows(at: [indexPath], with: .automatic)
			case .updateData(let indexPath):
				GalleryCache.removeCache(for: indexPath.row)
				self.screenView.tableView.reloadRows(at: [indexPath], with: .automatic)
			case .moveData(let indexPath, let newIndexPath):
				GalleryCache.removeCache(for: indexPath.row)
				if indexPath.row > 0 {
					GalleryCache.slideDownCache(before: indexPath.row)
				}

				self.screenView.tableView.moveRow(at: indexPath, to: newIndexPath)
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
					self?.screenView.tableView.reloadRows(at: [newIndexPath], with: .automatic)
				}
			}
		}
	}
	
	private func configureObserver() {
		NotificationCenter.default.addObserver(self, selector: #selector(didFinishAddNewDocumentGroup), name: NSNotification.Name("didFinishAddNewDocumentGroup"), object: nil)
	}
	
	@objc func didFinishAddNewDocumentGroup() {
		screenView.tableView.delegate?.tableView?(self.screenView.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
	}
	
	private func configureNavigationItemForEditingState() {
		navigationItem.leftBarButtonItems = leftBarButtonItemsEditingState
		navigationItem.rightBarButtonItems = rightBarButtonItemsEditingState
		
		navigationController?.setToolbarHidden(false, animated: true)
	}
	
	private func configureNavigationItemForNormalState() {
		navigationItem.leftBarButtonItems = leftBarButtonItemsNormalState
		navigationItem.rightBarButtonItems = rightBarButtonItemsNormalState
		
		navigationController?.setToolbarHidden(true, animated: true)
	}
	
	private func deleteData(indexes: [Int]) {
		var itemsToDelete = [DocumentGroup]()
		for i in indexes {
			GalleryCache.removeCache(for: i)
			itemsToDelete.append(model.fetchedResultsController.object(at: IndexPath(row: i, section: 0)))
		}
		
		model.deleteData(documentGroupsToDelete: itemsToDelete)
	}
	
	private func saveAllDocument(_ index: Int) {
		guard let documents = model.fetchedResultsController.object(at: IndexPath(row: index, section: 0)).documents.allObjects as? [Document] else { return }
		
		DispatchQueue.global(qos: .userInitiated).async {
			
			for document in documents {
				guard let image = UIImage(data: document.thumbnail) else { return }
				
				UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
			}
			
			ThreadManager.executeOnMain {
				self.screenView.showSaveAlert(count: documents.count)
			}
		}
		
	}
}
