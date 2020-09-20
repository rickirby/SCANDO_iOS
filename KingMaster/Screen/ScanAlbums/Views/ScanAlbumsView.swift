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
		case didTapCamera
		case didTapPicker
		case didSelectRow(index: Int)
		case editingStart
		case editingEnd
		case selectAll
		case delete(indexes: [Int])
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	var viewDataSupply: (() -> [DocumentGroup])?
	
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
	
	private func setTableViewEditingState(isEditing: Bool) {
		if isEditing {
			tableView.setEditing(true, animated: true)
			onViewEvent?(.editingStart)
		} else {
			tableView.setEditing(false, animated: true)
			onViewEvent?(.editingEnd)
		}
	}
	
	private func swipeDeleteHandler(index: Int, _ complete: @escaping (Bool) -> Void) {
		guard let vc = findViewController() else { return }
		
		AlertView.createSwipeDeleteAlert(vc, deleteHandler: {
			self.onViewEvent?(.delete(indexes: [index]))
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
}

extension ScanAlbumsView {
	
	// MARK: - @Objc Target
	
	@objc func cameraBarButtonTapped() {
		onViewEvent?(.didTapCamera)
	}
	
	@objc func fileBarButtonTapped() {
		onViewEvent?(.didTapPicker)
	}
	
	@objc func cancelBarButtonTapped() {
		setTableViewEditingState(isEditing: false)
	}
	
	@objc func selectAllBarButtonTapped() {
		for i in 0 ..< (viewDataSupply?().count ?? 0) {
			let indexPath = IndexPath(row: i, section: 0)
			guard let _ = tableView.cellForRow(at: indexPath) else { return }
			tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
		}
	}
	
	@objc func deleteBarButtonTapped() {
		guard let selectedIndexPaths = tableView.indexPathsForSelectedRows, let vc = findViewController() else { return }
		let selectedIndexes = selectedIndexPaths.map { $0.row }
		
		AlertView.createBarDeleteAlert(vc, isSingular: selectedIndexes.count == 1, deleteHandler: {
			self.onViewEvent?(.delete(indexes: selectedIndexes))
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
				self.setTableViewEditingState(isEditing: false)
			}
		}, cancelHandler: {
			
		})
	}
	
	@objc func startEditTableView(_ gesture: UILongPressGestureRecognizer) {
		if gesture.state == .began && !tableView.isEditing {
			let point = gesture.location(in: tableView)
			guard let indexPath = tableView.indexPathForRow(at: point), let _ = tableView.cellForRow(at: indexPath) else { return }
			let generator = UIImpactFeedbackGenerator()
			generator.impactOccurred()
			setTableViewEditingState(isEditing: true)
			tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
		}
	}
}

extension ScanAlbumsView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return viewDataSupply?().count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanAlbumsCell", for: indexPath) as? ScanAlbumsTableViewCell, let object = viewDataSupply?()[indexPath.row] else {
			return UITableViewCell()
		}
		
		cell.configure(with: object)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("Didselect")
		if !tableView.isEditing {
			onViewEvent?(.didSelectRow(index: indexPath.row))
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		print("Deselect")
		if tableView.isEditing && tableView.indexPathsForSelectedRows?.count ?? 0 == 0 {
			setTableViewEditingState(isEditing: false)
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
