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
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	
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
	
	// MARK: - Life Cycle
	
	override func setViews() {
		configureView()
		configureTableView()
	}
	
	// MARK: - Public Method
	
	func reloadData() {
		tableView.reloadData()
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
	
}

extension ScanAlbumsView {
	
	// MARK: - @Objc Target
	
	@objc func cameraBarButtonTapped() {
		
	}
	
	@objc func fileBarButtonTapped() {
		
	}
	
	@objc func startEditTableView(_ gesture: UILongPressGestureRecognizer) {
		if gesture.state == .began && !tableView.isEditing {
			let point = gesture.location(in: tableView)
			guard let indexPath = tableView.indexPathForRow(at: point), let _ = tableView.cellForRow(at: indexPath) else { return }
			let generator = UIImpactFeedbackGenerator()
			generator.impactOccurred()
			tableView.setEditing(true, animated: true)
			tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
			
			onViewEvent?(.editingStart)
		}
	}
}

extension ScanAlbumsView: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScanAlbumsCell", for: indexPath) as? ScanAlbumsTableViewCell else {
			return UITableViewCell()
		}
		cell.configureCell(image: #imageLiteral(resourceName: "ICON"), document: "Scando", date: "11/11/20", number: 3)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		onViewEvent?(.didSelectRow(index: indexPath.row))
	}
}
