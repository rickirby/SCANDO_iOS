//
//  FilterV2ViewController.swift
//  KingMaster
//
//  Created by Ricki Bin Yamin on 07/12/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit
import RBToolkit
import RBImageProcessor

class FilterV2ViewController: ViewController<FilterView> {
	
	// MARK: - Public Properties
	
	var passedData: (() -> FilterCoordinator.FilterData)?
	
	// MARK: - Private Properties
	
	var convertColor: ConvertColor?
	var readDot: ReadDot?
	
	var erodeImage: UIImage?
	var blobAnalysisImage: UIImage?
	
	var rawContorusImage: UIImage?
	var filteredContoursImage: UIImage?
	var redrawImage: UIImage?
	var lineCoordinateImage: UIImage?
	var segmentationImage: UIImage?
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureImageProcessor()
		configureViewState()
		configureLoadBar()
		configureViewEvent()
		loadData()
	}
	
	// MARK: - Private Methods
	
	private func configureImageProcessor() {
		let adaptiveParam = AdaptiveParamUserSetting.shared.read()
		let dilateParam = DilateParamUserSetting.shared.read()
		let erodeParam = ErodeParamUserSetting.shared.read()
		
		convertColor = ConvertColor(adaptiveType: (adaptiveParam?.type ?? 1) == 1, adaptiveBlockSize: adaptiveParam?.blockSize ?? 57, adaptiveConstant: adaptiveParam?.constant ?? 7, dilateIteration: dilateParam?.iteration ?? 1, erodeIteration: erodeParam?.iteration ?? 3)
		
		readDot = ReadDot(adaptiveType: (adaptiveParam?.type ?? 1) == 1, adaptiveBlockSize: adaptiveParam?.blockSize ?? 57, adaptiveConstant: adaptiveParam?.constant ?? 7, dilateIteration: dilateParam?.iteration ?? 1, erodeIteration: erodeParam?.iteration ?? 3)
		// NOTES: done with the end of FPP-77 & FPP-82
	}
	
	private func configureViewState() {
		screenView.isV2 = true
	}
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.titleView = screenView.segmentControl
		toolbarItems = [screenView.downloadBarButton, spacer, screenView.adjustBarButton]
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: FilterView.ViewEvent) in
			switch viewEvent {
			case .didChangeSegment(let index):
				self?.refreshImage(index: index)
			case .didTapDownload:
				self?.downloadImage()
			default:
				break
			}
		}
	}
	
	private func loadData() {
		guard let passedData = passedData?() else {
			return
		}
		
		ThreadManager.executeOnMain {
			self.screenView.startLoading()
		}
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			
			// Erode Image
			
			self?.erodeImage = self?.convertColor?.erode(from: passedData.image)
			
			// Blob Analysis Image
			self?.blobAnalysisImage = self?.readDot?.segmentation(from: passedData.image)
			
			// Raw Contours Image
			self?.rawContorusImage = self?.readDot?.rawContours(from: passedData.image)
			
			// Filtered Contours Image
			self?.filteredContoursImage = self?.readDot?.filteredContours(from: passedData.image)
			
			// Redraw Image
			self?.redrawImage = self?.readDot?.redraw(from: passedData.image)
			
			// Line Coordinate Image
			self?.lineCoordinateImage = self?.readDot?.lineCoordinate(from: passedData.image)
			
			// Segmentation Image
			self?.segmentationImage = self?.readDot?.segmentation(from: passedData.image)
			
			ThreadManager.executeOnMain {
				self?.screenView.stopLoading()
				self?.refreshImage(index: self?.screenView.segmentControl.selectedSegmentIndex ?? 0)
			}
		}
	}
	
	private func refreshImage(index: Int) {
		switch index {
		case 0:
			screenView.image = erodeImage
		case 1:
			screenView.image = rawContorusImage
		case 2:
			screenView.image = filteredContoursImage
		case 3:
			screenView.image = redrawImage
		case 4:
			screenView.image = lineCoordinateImage
		case 5:
			screenView.image = segmentationImage
		default:
			screenView.image = erodeImage
		}
		
		screenView.adjustBarButton.isEnabled = (index == -1)
	}
	
	private func downloadImage() {
		guard let image = screenView.image else { return }
		screenView.startLoading()
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			UIImageWriteToSavedPhotosAlbum(image, self, #selector(self?.image(_:didFinishSavingWithError:contextInfo:)), nil)
		}
	}
	
	@objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		screenView.stopLoading()
		screenView.showSaveAlert(on: self, error: error)
	}
}
