//
//  DocumentGroupView.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 06/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit

class DocumentGroupView: View {
	
	// MARK: - Public Properties
	
	enum ViewEvent {
		case didTapCamera
		case didTapPicker
		case didSelectRow(index: Int)
	}
	
	var onViewEvent: ((ViewEvent) -> Void)?
	var viewDataSupply: (() -> [Document])?
	
	// MARK: - Private Properties
	
	var collectionViewData: [UIImage?] = []
	
	// MARK: - View Component
	
	lazy var collectionView: UICollectionView = {
		
		let screenWidth = UIScreen.main.bounds.width
		let cellSpacing: CGFloat = 10
		let contentInset: CGFloat = 20
		let cellSize = (screenWidth - 2 * contentInset) / 2 - cellSpacing
		
		let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        layout.minimumLineSpacing = screenWidth - 2 * (cellSize + contentInset)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemBackground
		collectionView.contentInset = UIEdgeInsets(top: contentInset, left: contentInset, bottom: contentInset, right: contentInset)
		collectionView.alwaysBounceVertical = true
		
		return collectionView
	}()
	
	lazy var cameraBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraBarButtonTapped))
	
	lazy var fileBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(fileBarButtonTapped))
	
	// MARK: - Life Cycle
	
	override func setViews() {
		super.setViews()
		
		configureView()
		configureCollectionView()
	}
	
	// MARK: - Public Method
	
	func scrollToEnd() {
		guard let count = viewDataSupply?().count else { return }
		
		collectionView.scrollToItem(at: IndexPath(row: count - 1, section: 0), at: .centeredVertically, animated: true)
	}
	
	// MARK: - Private Method
	
	private func configureView() {
		addAllSubviews(views: [collectionView])
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: self.topAnchor),
			collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
			collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		])
	}
	
	private func configureCollectionView() {
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.register(DocumentGroupCollectionViewCell.self, forCellWithReuseIdentifier: "DocumentGroupCell")
	}

}

extension DocumentGroupView {
	
	// MARK: - @Objc Target
	
	@objc func cameraBarButtonTapped() {
		onViewEvent?(.didTapCamera)
	}
	
	@objc func fileBarButtonTapped() {
		onViewEvent?(.didTapPicker)
	}
}

extension DocumentGroupView: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return (viewDataSupply?().count ?? 0) + 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentGroupCell", for: indexPath) as? DocumentGroupCollectionViewCell, indexPath.row < (viewDataSupply?().count ?? 0) + 1 else {
			return UICollectionViewCell()
		}
		
		if indexPath.row < viewDataSupply?().count ?? 0 {
			guard let object = viewDataSupply?()[indexPath.row] else {
				return UICollectionViewCell()
			}
			cell.configure(with: object)
		} else {
			cell.configure(with: UIImage(named: "TapToAdd"))
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		onViewEvent?(.didSelectRow(index: indexPath.row))
	}
}
