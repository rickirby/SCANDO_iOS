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
		case didSelectRow(index: Int, object: DocumentGroup)
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	// MARK: - Private Properties
	
	private let model = ScanAlbumsModel()
	
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
		model.onModelEvent = { (modelEvent: ScanAlbumsModel.ModelEvent) in
			switch modelEvent {
			case .beginUpdates:
				self.screenView.tableView.beginUpdates()
			case .endUpdates:
				self.screenView.tableView.endUpdates()
			case .insertData(let newIndexPath):
				self.screenView.tableView.insertRows(at: [newIndexPath], with: .automatic)
			case .deleteData(let indexPath):
				self.screenView.tableView.deleteRows(at: [indexPath], with: .automatic)
			case .updateData(let indexPath):
				self.screenView.tableView.reloadRows(at: [indexPath], with: .automatic)
			case .moveData(let indexPath, let newIndexPath):
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
		GalleryCache.slideDownAllCache()
		screenView.tableView.delegate?.tableView?(self.screenView.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
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
		var itemsToDelete = [DocumentGroup]()
		for i in indexes {
			GalleryCache.removeCache(for: i)
			GalleryCache.slideUpCache(after: i)
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
				self.screenView.showSaveAlert(error: nil)
			}
		}
		
	}
}
