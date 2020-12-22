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
import RBPhotosGallery

class FilterV2ViewController: RBPhotosGalleryViewController {
	
	// MARK: - Public Properties
	
	var passedData: (() -> FilterCoordinator.FilterData)?
	
	// MARK: - Private Properties
	
	var screenView = FilterView()
	
	var convertColor: ConvertColor?
	var readDot: ReadDot?
	
	var erodeImage: UIImage?
	
	var rawContorusImage: UIImage?
	var filteredContoursImage: UIImage?
	var redrawImage: UIImage?
	var lineCoordinateImage: UIImage?
	var segmentationImage: UIImage?
	
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
		let blobAnalysisParam = BlobAnalysisParamUserSetting.shared.read()
		
		convertColor = ConvertColor(adaptiveType: (adaptiveParam?.type ?? 1) == 1, adaptiveBlockSize: adaptiveParam?.blockSize ?? 57, adaptiveConstant: adaptiveParam?.constant ?? 7, dilateIteration: dilateParam?.iteration ?? 1, erodeIteration: erodeParam?.iteration ?? 3)
		
		readDot = ReadDot(adaptiveType: (adaptiveParam?.type ?? 1) == 1, adaptiveBlockSize: adaptiveParam?.blockSize ?? 57, adaptiveConstant: adaptiveParam?.constant ?? 7, dilateIteration: dilateParam?.iteration ?? 1, erodeIteration: erodeParam?.iteration ?? 3, minAreaContourFilter: blobAnalysisParam?.minAreaContourFilter ?? 200, maxAreaContourFilter: blobAnalysisParam?.maxAreaContourFilter ?? 500, redrawCircleSize: blobAnalysisParam?.redrawCircleSize ?? 10, maxSpaceForGroupingSameRowAndCols: blobAnalysisParam?.maxSpaceForGroupingSameRowAndCols ?? 20, maxDotSpaceInterDot: blobAnalysisParam?.maxDotSpaceInterDot ?? 40, defaultDotSpaceInterDot: blobAnalysisParam?.defaultDotSpaceInterDot ?? 30)
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
			case .didTapAdjust:
				self?.adjustParam()
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
				
				self?.galleryViewImagesData = [self?.erodeImage, self?.rawContorusImage, self?.filteredContoursImage, self?.redrawImage, self?.lineCoordinateImage, self?.segmentationImage]
				self?.reloadPhotosData()
				self?.refreshImage(index: self?.screenView.segmentControl.selectedSegmentIndex ?? 0)
				self?.screenView.stopLoading()
			}
		}
	}
	
	private func refreshImage(index: Int) {
		self.scrollToPhotos(index: index)
		
		screenView.adjustBarButton.isEnabled = (index == 2) || (index == 3) || (index == 4) || (index == 5)
	}
	
	private func adjustParam() {
		let blobAnalysisParam = BlobAnalysisParamUserSetting.shared.read()
		
		AlertView.createBlobAnalysisParamAlert(self, currentMinArea: blobAnalysisParam?.minAreaContourFilter, currentMaxArea: blobAnalysisParam?.maxAreaContourFilter, currentCircleSize: blobAnalysisParam?.redrawCircleSize, currentSpaceForGroupingSameRowCols: blobAnalysisParam?.maxSpaceForGroupingSameRowAndCols, currentMaxDotSpaceInterDot: blobAnalysisParam?.maxDotSpaceInterDot, currentDefaultDotSpaceInterDot: blobAnalysisParam?.defaultDotSpaceInterDot, setHandler: {
			guard
				let textField0Text = $0.text,
				let textField1Text = $1.text,
				let textField2Text = $2.text,
				let textField3Text = $3.text,
				let textField4Text = $4.text,
				let textField5Text = $5.text,
				let minAreaContourFilter = Double(textField0Text),
				let maxAreaContourFilter = Double(textField1Text),
				let circleSize = Double(textField2Text),
				let maxSpaceForGroupingSameRowCols = Double(textField3Text),
				let maxDotSpaceInterDot = Double(textField4Text),
				let defaultDotSpaceInterDot = Double(textField5Text)
			else {
				// Provide default value if text field error or empty
				DispatchQueue.global(qos: .userInitiated).async {
					
					self.readDot?.setMinAreaContourFilter(200)
					self.readDot?.setMaxAreaContourFilter(500)
					self.readDot?.setRedrawCircleSize(10)
					self.readDot?.setMaxSpaceForGroupingSameRowAndCols(20)
					self.readDot?.setMaxDotSpaceInter(40)
					self.readDot?.setDefaultDotSpaceInter(30)
					
					BlobAnalysisParamUserSetting.shared.save(BlobAnalysisParamUserSetting.BlobAnalysisParam(minAreaContourFilter: 200, maxAreaContourFilter: 500, redrawCircleSize: 10, maxSpaceForGroupingSameRowAndCols: 20, maxDotSpaceInterDot: 40, defaultDotSpaceInterDot: 30))
					
					self.loadData()
				}
				
				return
			}
			
			DispatchQueue.global(qos: .userInitiated).async {
				
				self.readDot?.setMinAreaContourFilter(minAreaContourFilter)
				self.readDot?.setMaxAreaContourFilter(maxAreaContourFilter)
				self.readDot?.setRedrawCircleSize(circleSize)
				self.readDot?.setMaxSpaceForGroupingSameRowAndCols(maxSpaceForGroupingSameRowCols)
				self.readDot?.setMaxDotSpaceInter(maxDotSpaceInterDot)
				self.readDot?.setDefaultDotSpaceInter(defaultDotSpaceInterDot)
				
				BlobAnalysisParamUserSetting.shared.save(BlobAnalysisParamUserSetting.BlobAnalysisParam(minAreaContourFilter: minAreaContourFilter, maxAreaContourFilter: maxAreaContourFilter, redrawCircleSize: circleSize, maxSpaceForGroupingSameRowAndCols: maxSpaceForGroupingSameRowCols, maxDotSpaceInterDot: maxDotSpaceInterDot, defaultDotSpaceInterDot: defaultDotSpaceInterDot))
				
				self.loadData()
			}
			
		}, cancelHandler: {})
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
}

extension FilterV2ViewController: RBPhotosGalleryViewDelegate, RBPhotosGalleryViewDataSource {
	
	func photosGalleryImages() -> [UIImage] {
		return galleryViewImagesData.compactMap { $0 }
	}
}
