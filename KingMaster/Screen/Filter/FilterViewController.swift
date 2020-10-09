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

class FilterViewController: ViewController<FilterView> {
	
	// MARK: - Public Properties
	
	var passedData: (() -> FilterCoordinator.FilterData)?
	
	// MARK: - Private Properties
	
	var originalImage: UIImage?
	var grayImage: UIImage?
	var adaptiveThresholdImage: UIImage?
	
	// MARK: - Life Cycles
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		configureLoadBar()
		loadData()
		configureViewEvent()
	}
	
	// MARK: - Private Methods
	
	private func configureLoadBar() {
		let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
		navigationItem.titleView = screenView.segmentControl
		toolbarItems = [screenView.adjustBarButton ,spacer, screenView.downloadBarButton]
	}
	
	private func loadData() {
		guard let passedData = passedData?() else { return }
		
		DispatchQueue.global(qos: .userInitiated).async { [weak self] in
			self?.originalImage = passedData.image
			self?.grayImage = ConvertColor.makeGray(from: passedData.image)
			self?.adaptiveThresholdImage = ConvertColor.adaptiveThreshold(from: passedData.image, isGaussian: true, blockSize: 57, constant: 7)
			
			ThreadManager.executeOnMain {
				self?.screenView.image = self?.originalImage
			}
		}
	}
	
	private func configureViewEvent() {
		screenView.onViewEvent = { [weak self] (viewEvent: FilterView.ViewEvent) in
			switch viewEvent {
			case .didChangeSegment(let index):
				self?.changeSegment(index: index)
			case .didTapDownload:
				self?.downloadImage()
			case .didTapAdjust:
				self?.adjustParam()
			}
		}
	}
	
	private func changeSegment(index: Int) {
		switch index {
		case 0:
			screenView.image = originalImage
		case 1:
			screenView.image = grayImage
		case 2:
			screenView.image = adaptiveThresholdImage
		default:
			screenView.image = originalImage
		}
		
		screenView.adjustBarButton.isEnabled = (index == 2)
	}
	
	private func downloadImage() {
		
	}
	
	private func adjustParam() {
		switch screenView.segmentControl.selectedSegmentIndex {
		case 2:
			adjustAdaptiveParam()
		default:
			break
		}
	}
	
	private func adjustAdaptiveParam() {
		guard let originalImage = originalImage else { return }
		
		let currentAdaptiveType = FilterUserSettting.shared.read(forKey: .adaptiveType)
		let currentAdaptiveBlockSize = FilterUserSettting.shared.read(forKey: .adaptiveBlockSize)
		let currentAdaptiveConstant = FilterUserSettting.shared.read(forKey: .adaptiveConstant)
		
		AlertView.createAdaptiveParamAlert(self, currentType: currentAdaptiveType, currentBlockSize: currentAdaptiveBlockSize, currentConstant: currentAdaptiveConstant, setHandler: {
			guard let textField0Text = $0.text, let textField1Text = $1.text, let textField2Text = $2.text, let type = Int(textField0Text), let blockSize = Int(textField1Text), let constant = Double(textField2Text) else {
				DispatchQueue.global(qos: .userInitiated).async {
					self.adaptiveThresholdImage = ConvertColor.adaptiveThreshold(from: originalImage, isGaussian: true, blockSize: 57, constant: 7)
					
					FilterUserSettting.shared.save(1, forKey: .adaptiveType)
					FilterUserSettting.shared.save(57, forKey: .adaptiveBlockSize)
					FilterUserSettting.shared.save(7, forKey: .adaptiveConstant)
					
					ThreadManager.executeOnMain {
						self.screenView.image = self.adaptiveThresholdImage
					}
				}
				
				return
			}
			
			DispatchQueue.global(qos: .userInitiated).async {
				self.adaptiveThresholdImage = ConvertColor.adaptiveThreshold(from: originalImage, isGaussian: (type == 1), blockSize: blockSize, constant: constant)
				
				FilterUserSettting.shared.save(type, forKey: .adaptiveType)
				FilterUserSettting.shared.save(blockSize, forKey: .adaptiveBlockSize)
				FilterUserSettting.shared.save(Int(constant), forKey: .adaptiveConstant)
				
				ThreadManager.executeOnMain {
					self.screenView.image = self.adaptiveThresholdImage
				}
			}
		}, cancelHandler: {})
	}
}
