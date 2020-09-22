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
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .systemBackground
		collectionView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
		
		return collectionView
	}()
	
	lazy var activityIndicator: UIActivityIndicatorView = {
		let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
		activityIndicator.color = .white
		activityIndicator.hidesWhenStopped = true
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		return activityIndicator
	}()
	
	lazy var cameraBarButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraBarButtonTapped))
	
	lazy var fileBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(fileBarButtonTapped))
	
	// MARK: - Life Cycle
	
	override func setViews() {
		super.setViews()
		
		configureView()
		configureCollectionView()
	}
	
	override func onViewWillAppear() {
		super.onViewWillAppear()
		
		prepareDataSupply()
	}
	
	override func onViewWillLayoutSubviews() {
		super.onViewWillLayoutSubviews()
		
		configureCollectionViewLayout()
	}
	
	
	// MARK: - Public Method
	
	func scrollToEnd() {
		guard let count = viewDataSupply?().count else { return }
		
		collectionView.scrollToItem(at: IndexPath(row: count - 1, section: 0), at: .centeredVertically, animated: true)
	}
	
	// MARK: - Private Method
	
	private func configureView() {
		addAllSubviews(views: [collectionView, activityIndicator])
		
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: self.topAnchor),
			collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
			collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
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
	
	private func prepareDataSupply() {
		activityIndicator.startAnimating()
		
		DispatchQueue.global(qos: .userInitiated).async {
			guard let data = self.viewDataSupply?() else { return }
			
			self.collectionViewData = data.map { UIImage(data: $0.image.originalImage) }
			
			ThreadManager.executeOnMain {
				self.activityIndicator.stopAnimating()
				self.collectionView.reloadData()
			}
		}
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
		return collectionViewData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentGroupCell", for: indexPath) as? DocumentGroupCollectionViewCell else {
			return UICollectionViewCell()
		}
		
		cell.configure(with: collectionViewData[indexPath.row])
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		onViewEvent?(.didSelectRow(index: indexPath.row))
	}
}
