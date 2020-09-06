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
		let cellSize = self.bounds.width / 2 - 30
		
		let layout = UICollectionViewFlowLayout()
		layout.scrollDirection = .vertical
		layout.itemSize = CGSize(width: cellSize, height: cellSize)
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemBackground
		
		return collectionView
	}()
	
	// MARK: - Life Cycle
	
	override func setViews() {
		super.setViews()
		
		configureCollectionView()
	}
	
	// MARK: - Private Method
	
	func configureCollectionView() {
		
	}
}
