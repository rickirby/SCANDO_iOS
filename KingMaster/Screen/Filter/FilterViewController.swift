//
//  FilterViewController.swift
//  Production
//
//  Created by Ricki Private on 07/10/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBImageProcessor
import RBPhotosGallery

class FilterViewController: RBPhotosGalleryViewController {
	
	enum NavigationEvent {
		case didTapNext
	}
	
	var onNavigationEvent: ((NavigationEvent) -> Void)?
	
	// MARK: - Public Properties
	
	var passedData: (() -> FilterCoordinator.FilterData)?
	
	// MARK: - Private Properties
	
	var screenView = FilterView()
	
	var convertColor: ConvertColor?
	
	var originalImage: UIImage?
	var grayImage: UIImage?
	var adaptiveThresholdImage: UIImage?
	var dilateImage: UIImage?
	var erodeImage: UIImage?
	
	var galleryViewImagesData: [UIImage?] = []
	
	// MARK: - Life Cycles
	
	override func loadView() {
		super.loadView()
		
		view.backgroundColor = .systemBackground
		view.addSubview(screenView.activityIndicator)
		
		NSLayoutConstraint.activate([
			screenView.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			screenView.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureImageProcessor()
		configureLoadBar()
		loadData()
		configureViewEvent()
	}
	
	// MARK: - Private Methods
	
	private func configureImageProcessor() {
		let adaptiveParam = AdaptiveParamUserSetting.shared.read()
		let dilateParam = DilateParamUserSetting.shared.read()
		let erodeParam = ErodeParamUserSetting.shared.read()
		
		convertColor = ConvertColor(adaptiveType: (adaptiveParam?.type ?? 1) == 1, adaptiveBlockSize: adaptiveParam?.blockSize ?? 57, adaptiveConstant: adaptiveParam?.constant ?? 7, dilateIteration: dilateParam?.iteration ?? 1, erodeIteration: erodeParam?.iteration ?? 3)
	}
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.titleView = screenView.segmentControl
		toolbarItems = [screenView.downloadBarButton, spacer, screenView.adjustBarButton, spacer, screenView.nextBarButton]
	}
	
	private func loadData() {
		guard let passedData = passedData?() else {
			return
		}
		
		ThreadManager.executeOnMain {
			self.screenView.startLoading()
		}
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			// Original Image
			self?.originalImage = passedData.image
			// Gray Image
			self?.grayImage = self?.convertColor?.makeGray(from: passedData.image)
			// Adaptive Threshold Image
			self?.adaptiveThresholdImage = self?.convertColor?.adaptiveThreshold(from: passedData.image)
			// Dilate Image
			self?.dilateImage = self?.convertColor?.dilate(from: passedData.image)
			// Erode Image
			self?.erodeImage = self?.convertColor?.erode(from: passedData.image)
			
			ThreadManager.executeOnMain {
				
				self?.galleryViewImagesData = [self?.originalImage, self?.grayImage, self?.adaptiveThresholdImage, self?.dilateImage, self?.erodeImage]
				self?.reloadPhotosData()
				self?.refreshImage(index: self?.screenView.segmentControl.selectedSegmentIndex ?? 0)
				self?.screenView.stopLoading()
			}
		}
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: FilterView.ViewEvent) in
			switch viewEvent {
			case .didChangeSegment(let index):
				self?.refreshImage(index: index)
			case .didTapDownload:
				self?.downloadImage()
			case .didTapAdjust:
				self?.adjustParam()
			case .didTapNext:
				self?.nextFilter()
			}
		}
	}
	
	private func refreshImage(index: Int) {
		self.scrollToPhotos(index: index)
		
		screenView.adjustBarButton.isEnabled = (index == 2) || (index == 3) || (index == 4)
	}
	
	private func downloadImage() {
		guard let image = galleryViewImagesData[currentPageIndex] else {
			return
		}
		
		screenView.startLoading()
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
		}
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		screenView.stopLoading()
		screenView.showSaveAlert(on: self, error: error)
    }
	
	private func nextFilter() {
		onNavigationEvent?(.didTapNext)
	}
	
	private func adjustParam() {
		switch screenView.segmentControl.selectedSegmentIndex {
		case 2:
			adjustAdaptiveParam()
		case 3:
			adjustDilateParam()
		case 4:
			adjustErodeParam()
		default:
			break
		}
	}
	
	private func adjustAdaptiveParam() {
		
		let adaptiveParam = AdaptiveParamUserSetting.shared.read()
		
		AlertView.createAdaptiveParamAlert(self, currentType: adaptiveParam?.type, currentBlockSize: adaptiveParam?.blockSize, currentConstant: adaptiveParam?.constant, setHandler: {
			
			guard let textField0Text = $0.text, let textField1Text = $1.text, let textField2Text = $2.text, let type = Int(textField0Text), let blockSize = Int(textField1Text), let constant = Double(textField2Text) else {
				// Provide default value if text field error or empty
				DispatchQueue.global(qos: .userInitiated).async {
					
					self.convertColor?.setAdaptiveType(true)
					self.convertColor?.setAdaptiveBlockSize(57)
					self.convertColor?.setAdaptiveConstant(7)
					
					AdaptiveParamUserSetting.shared.save(AdaptiveParamUserSetting.AdaptiveParam(type: 1, blockSize: 57, constant: 7))
					
					self.loadData()
				}
				
				return
			}
			
			if (blockSize > 1) && (blockSize % 2) == 1 {
				// Check if blockSize value is acceptable to avoid crash
				DispatchQueue.global(qos: .userInitiated).async {
					
					self.convertColor?.setAdaptiveType(type == 1)
					self.convertColor?.setAdaptiveBlockSize(blockSize)
					self.convertColor?.setAdaptiveConstant(constant)
					
					AdaptiveParamUserSetting.shared.save(AdaptiveParamUserSetting.AdaptiveParam(type: type, blockSize: blockSize, constant: constant))
					
					self.loadData()
				}
			} else {
				AlertView.createAdaptiveParamErrorAlert(self)
			}
			
		}, cancelHandler: {})
	}
	
	private func adjustDilateParam() {
		
		let dilateParam = DilateParamUserSetting.shared.read()
		
		AlertView.createDilateParamAlert(self, currentIteration: dilateParam?.iteration, setHandler: {
			
			guard let textFieldText = $0.text, let iteration = Int(textFieldText) else { return }
			
			DispatchQueue.global(qos: .userInitiated).async {
				
				self.convertColor?.setDilateIteration(iteration)
				DilateParamUserSetting.shared.save(DilateParamUserSetting.DilateParam(iteration: iteration))
				
				self.loadData()
			}
			
		}, cancelHandler: {})
	}
	
	private func adjustErodeParam() {
		
		let erodeParam = ErodeParamUserSetting.shared.read()
		
		AlertView.createErodeParamAlert(self, currentIteration: erodeParam?.iteration, setHandler: {
			
			guard let textFieldText = $0.text, let iteration = Int(textFieldText) else { return }
			
			DispatchQueue.global(qos: .userInitiated).async {
				
				self.convertColor?.setErodeIteration(iteration)
				ErodeParamUserSetting.shared.save(ErodeParamUserSetting.ErodeParam(iteration: iteration))
				
				self.loadData()
			}
		}, cancelHandler: {})
	}
}

extension FilterViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return galleryViewImagesData.compactMap { $0 }
	}
}
