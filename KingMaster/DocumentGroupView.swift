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
		
		let layout = UICollectionViewFlowLayout()
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
		
		let cellSize = self.bounds.width / 2 - 20
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: cellSize, height: cellSize)
		
		collectionView.setCollectionViewLayout(layout, animated: true)
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
