//
//  ScanAlbumsView.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class ScanAlbumsView: View {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didSelectRow(index: Int)
		case editingStart
		case editingEnd
		case selectAll
		case delete(indexes: [Int])
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
	// MARK: - Private Properties
	
	private var tableViewData = [String]()
	
	// MARK: - View Component
	
	lazy var tableView: UITableView = {
		let gesture = UILongPressGestureRecognizer(target: self, action: #selector(startEditTableView(_:)))
		gesture.minimumPressDuration = 0.5
		
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.separatorInset = UIEdgeInsets.zero
		tableView.tableFooterView = UIView()
		tableView.allowsSelectionDuringEditing = true
		tableView.allowsMultipleSelectionDuringEditing = true
		tableView.addGestureRecognizer(gesture)
		
		return tableView
	}()
	
	lazy var cameraBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraBarButtonTapped))
	
	lazy var fileBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(fileBarButtonTapped))
	
	lazy var cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonTapped))
	
	lazy var selectAllBarButton = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(selectAllBarButtonTapped))
	
	lazy var deselectAllBarButton = UIBarButtonItem(title: "Deselect All", style: .plain, target: self, action: #selector(selectAllBarButtonTapped))
	
	lazy var deleteBarButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteBarButtonTapped))
	
	// MARK: - Life Cycle
	
	override func setViews() {
		configureView()
		configureTableView()
	}
	
	override func onViewWillAppear() {
		super.onViewWillAppear()
		
		if let indexPath = tableView.indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}
	
	override func onViewDidAppear() {
		super.onViewDidAppear()
		
		tableView.reloadData()
	}
	
	// MARK: - Public Method
	
	func reloadData(tableData: [String]) {
		tableViewData = tableData
	}
	
	// MARK: - Private Method
	
	private func configureView() {
		backgroundColor = .systemBackground
		addAllSubviews(views: [tableView])
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.topAnchor),
			tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
	private func configureTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ScanAlbumsTableViewCell.self, forCellReuseIdentifier: "ScanAlbumsCell")
	}
    
    private func swipeDeleteHandler(index: Int, _ complete: @escaping (Bool) -> Void) {
        print("Delete \(index)")
        guard let vc = findViewController() else { return }
        
        AlertView.createSwipeDeleteAlert(vc, deleteHandler: {
			self.deleteDataFromTableView(indexes: [index])
        }, cancelHandler: {
            complete(true)
        })
    }
    
    private func swipeMoreHandler(index: Int, _ complete: @escaping (Bool) -> Void) {
        print("More \(index)")
		guard let vc = findViewController() else { return }
		
		AlertView.createSwipeMoreSheet(vc, renameHandler: {
			print("Rename")
		}, saveHandler: {
			print("Save")
		}, changeHandler: {
			print("Change")
		}, deleteHandler: {
			print("Delete")
		}, cancelHandler:  {
			print("Cancel")
			complete(true)
		})
    }
	
	private func deleteDataFromTableView(indexes: [Int]) {
		let indexPaths = indexes.map { IndexPath(row: $0, section: 0)}
		onViewEvent?(.delete(indexes: indexes))
		tableView.deleteRows(at: indexPaths, with: .automatic)
	}
	
}

extension ScanAlbumsView {
	
	// MARK: - @Objc Target
	
	@objc func cameraBarButtonTapped() {
		
	}
	
	@objc func fileBarButtonTapped() {
		
	}
	
	@objc func cancelBarButtonTapped() {
		tableView.setEditing(false, animated: true)
		
		onViewEvent?(.editingEnd)
	}
	
	@objc func selectAllBarButtonTapped() {
		onViewEvent?(.selectAll)
	}
	
	@objc func deselectAllBarButtonTapped() {
		onViewEvent?(.selectAll)
	}
	
	@objc func deleteBarButtonTapped() {
		guard let selectedIndexPaths = tableView.indexPathsForSelectedRows, let vc = findViewController() else { return }
		let selectedIndexes = selectedIndexPaths.map { $0.row }
		
		AlertView.createBarDeleteAlert(vc, isSingular: selectedIndexPaths.count == 1, deleteHandler: {
			self.deleteDataFromTableView(indexes: selectedIndexes)
			self.tableView.setEditing(false, animated: true)
			self.onViewEvent?(.editingEnd)
		}, cancelHandler: {
			
		})
	}
	
	@objc func startEditTableView(_ gesture: UILongPressGestureRecognizer) {
		if gesture.state == .began && !tableView.isEditing {
			let point = gesture.location(in: tableView)
			guard let indexPath = tableView.indexPathForRow(at: point), let _ = tableView.cellForRow(at: indexPath) else { return }
			let generator = UIImpactFeedbackGenerator()
			generator.impactOccurred()
			tableView.setEditing(true, animated: true)
			tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
			deleteBarButton.isEnabled = true
			
			onViewEvent?(.editingStart)
		}
	}
}

extension ScanAlbumsView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return tableViewData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanAlbumsCell", for: indexPath) as? ScanAlbumsTableViewCell else {
			return UITableViewCell()
		}
		cell.configureCell(image: #imageLiteral(resourceName: "ICON"), document: tableViewData[indexPath.row], date: "11/11/20", number: 3)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Didselect")
		if !tableView.isEditing {
			onViewEvent?(.didSelectRow(index: indexPath.row))
		} else {
			deleteBarButton.isEnabled = tableView.indexPathsForSelectedRows?.count ?? 0 > 0
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		print("Deselect")
		if tableView.isEditing {
			if tableView.indexPathsForSelectedRows?.count ?? 0 > 0 {
				deleteBarButton.isEnabled = true
			} else {
				tableView.setEditing(false, animated: true)
				onViewEvent?(.editingEnd)
			}
        }
	}
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            _, _, complete in
            self.swipeDeleteHandler(index: indexPath.row, complete)
        }
        
        let moreAction = UIContextualAction(style: .normal, title: "More") {
            _, _, complete in
            self.swipeMoreHandler(index: indexPath.row, complete)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, moreAction])
    }
}
