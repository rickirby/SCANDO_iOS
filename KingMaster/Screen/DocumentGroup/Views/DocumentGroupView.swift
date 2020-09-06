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
	
	lazy var collectionView: UICollectionView = {
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemBackground
		collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		
		return collectionView
	}()
	
	// MARK: - Life Cycle
	
	override func setViews() {
		super.setViews()
		
		configureView()
		configureCollectionView()
	}
	
	override func onViewWillLayoutSubviews() {
		super.onViewWillLayoutSubviews()
		
		configureCollectionViewLayout()
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
	
	private func configureCollectionViewLayout() {
		let cellSpacing: CGFloat = 10
		let contentInset: CGFloat = 20
		let cellSize = (self.bounds.width - 2 * contentInset) / 2 - cellSpacing
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: cellSize, height: cellSize)
		layout.minimumLineSpacing = self.bounds.width - 2 * (cellSize + contentInset)
		
		collectionView.setCollectionViewLayout(layout, animated: true)
		collectionView.contentInset = UIEdgeInsets(top: contentInset, left: contentInset, bottom: contentInset, right: contentInset)
	}
}

extension DocumentGroupView: UICollectionViewDelegate, UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentGroupCell", for: indexPath) as? DocumentGroupCollectionViewCell else {
			return UICollectionViewCell()
		}
		cell.configureCell(image: #imageLiteral(resourceName: "Mask"))
		
		return cell
	}
	
	
}
