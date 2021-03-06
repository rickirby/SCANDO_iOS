//
//  SCANDOConstant.swift
//  KingMaster
//
//  Created by Ricki Private on 11/09/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import UIKit

class SCANDOConstant {
	
	static let swipeDeleteTitle: String = "Delete Document"
	static let swipeDeleteMessage: String = "Are you sure you want to delete the scanned documents album?"
	static let swipeDeletePositiveAction: String = "Delete"
	static let swipeDeleteNegativeAction: String = "Cancel"
	
	static let barDeleteTitle: String = "Delete Document"
	static let singleBarDeleteMessage: String = "Are you sure you want to delete the selected scanned document album?"
	static let pluralBarDeletelMessage: String = "Are you sure you want to delete the selected scanned document albums?"
	static let barDeletePositiveAction: String = "Delete"
	static let barDeleteNegativeAction: String = "Cancel"
	
	static let galleryDeleteTitle: String = "Delete Document"
	static let galleryDeleteMessage: String = "Are you sure you want to delete displayed document?"
	static let galleryDeletePositiveAction: String = "Delete"
	static let galleryDeleteNegativeAction: String = "Cancel"
	
	static let swipeMoreRenameAction: String = "Rename"
	static let swipeMoreSaveAction: String = "Save to Photos"
	static let swipeMoreDeleteAction: String = "Delete"
	static let swipeMoreCancelAction: String = "Cancel"
	
	static let saveSuccessTitle: String = "Saved!"
	static let saveOriginalSuccessMessage: String = "The original image has been saved to your Photos"
	static let saveProcessedSuccessMessage: String = "The processed image has been saved to your Photos"
	static let saveAllImageSuccessMessage: String = " image has been saved to your Photos"
	static let saveAllImagesSuccessMessage: String = " images has been saved to your Photos"
	static let saveErrorTitle: String = "Save Error!"
	static let saveAction: String = "OK"
	
	static let renameTitle: String = "Rename"
	static let renamePlaceholder: String = "New Name"
	static let renamePositiveAction: String = "OK"
	static let renameNegativeAction: String = "Cancel"
	
	static let addNewScanAlbumTitle: String = "Add New Scan Album"
	static let addNewScanAlbumMessage: String = "Insert a Title for New Scan Album"
	static let addNewScanAlbumPlaceholder: String = "New Title"
	static let addNewScanAlbumPositiveAction: String = "OK"
	static let addNewScanAlbumNegativeAction: String = "Cancel"
	
	static let setAdaptiveTitle: String = "Adaptive Parameter"
	static let setAdaptiveMessage: String = "Set value for following parameters."
	static let setAdaptiveTypePlaceholder: String = "Type 0: Mean, 1: Gauss"
	static let setAdaptiveBlockSizePlaceholder: String = "Block Size"
	static let setAdaptiveConstantPlaceholder: String = "Constant"
	static let setAdaptivePositiveAction: String = "OK"
	static let setAdaptiveNegativeAction: String = "Cancel"
	
	static let setAdaptiveParamErrorTitle: String = "Error"
	static let setAdaptiveParamErrorMessage: String = "Block Size value should be odd integer with value > 1"
	
	static let setDilateTitle: String = "Dilate Parameter"
	static let setDilateMessage: String = "Set value for following parameter"
	static let setDilateIterationPlaceholder: String = "Iteration"
	static let setDilatePositiveAction: String = "OK"
	static let setDilateNegativeAction: String = "Cancel"
	
	static let setErodeTitle: String = "Erode Parameter"
	static let setErodeMessage: String = "Set value for following parameter"
	static let setErodeIterationPlaceholder: String = "Iteration"
	static let setErodePositiveAction: String = "OK"
	static let setErodeNegativeAction: String = "Cancel"
	
	static let setBlobAnalysisParamTitle: String = "Segmentation Param"
	static let setBlobAnalysisParamMessage: String = "Set value for following parameters"
	static let setBlobAnalysisMinAreaPlaceholder: String = "Min Area Contour Filter"
	static let setBlobAnalysisMaxAreaPlaceholder: String = "Max Area Contour Filter"
	static let setBlobAnalysisCircleSizePlaceholder: String = "Redraw Circle Size"
	static let setBlobAnalysisMaxSpaceForGroupingSameRowColsPlaceholder: String = "Max Space for Grouping Same RowCols"
	static let setBlobAnalysisMaxDotSpaceInterDotPlaceholder: String = "Max Dot Space Inter-Dot"
	static let setBlobAnalysisDefaultDotSpaceInterDotPlaceholder: String = "Default Dot Space Inter-Dot"
	static let setBlobAnalysisPositiveAction: String = "OK"
	static let setBlobAnalysisNegativeAction: String = "Cancel"
	
	static let connectionStatusTitleConnected: String = "Everything is OK"
	static let connectionStatusDescriptionConnected: String = "You are all set. Connection status is okay. You are ready to copy braille page"
	static let connectionStatusPositiveButtonConnected: String = "Done"
	static let connectionStatusNegativeButtonConnected: String = "Reset Connection"
	
	static let connectionStatusTitleDisconnected: String = "Hi, there!"
	static let connectionStatusDescriptionDisconnected: String = "If you have supported Braille Printer, you can pair it with your iPhone here"
	static let connectionStatusPositiveButtonDisconnected: String = "Start Pairing"
	static let connectionStatusNegativeButtonDisconnected: String = "Cancel"
	
	static let connectionStatusTitleSharedConnected: String = "Everything is OK"
	static let connectionStatusDescriptionSharedConnected: String = "You are all set. You have been connected to shared network."
	static let connectionStatusPositiveButtonSharedConnected: String = "Done"
	static let connectionStatusNegativeButtonSharedConnected: String = "Reset Connection"
	
	static let connectionStatusTitleDifferentNetwork: String = "Something Needs to Set"
	static let connectionStatusDescriptionDifferentNetwork: String = "Make sure your iPhone have connected to same WiFi as you connect your Braille Printer"
	static let connectionStatusPositiveButtonDifferentNetwork: String = "Refresh Status"
	static let connectionStatusNegativeButtonDifferentNetwork: String = "Reset Connection"
	
	static let connectionStatusLearnMoreButton: String = "Learn more about Braille Printer"
	
	static let connectionModeTitle: String = "Connection Mode"
	static let connectionModeMessage: String = "Which way would you like to connect with Braille Printer?"
	static let connectionModeDirectAction: String = "Direct Connection"
	static let connectionModeSharedAction: String = "Shared Connection"
	static let connectionModeCancelActiion: String = "Cancel"
	
	static let connectionResetTitle: String = "Reset Connection"
	static let connectionResetMessage: String = "Are you sure you want to reset connection setting?"
	static let connectionResetDesctructiveAction: String = "Reset"
	static let connectionResetCancelAction: String = "Cancel"
	
	static let connectToWifiAskPasswordTitle: String = "Password"
	static let connectToWifiAskPasswordMessage: String = "Input password for "
	static let connectToWifiAskPasswordConnectAction: String = "OK"
	static let connectToWifiAskPasswordCancelAction: String = "Cancel"
	
	static let connectToWifiSuccessTitle: String = "Connected!"
	static let connectToWifiErrorTitle: String = "Failed!"
	static let connectToWifiSuccessMessage: String = "Success connecting your Braille Printer to "
	static let connectToWifiErrorMessage: String = "Can not connect to selected WiFi network. Re-check the password and try again"
	static let connectToWifiResultOkAction: String = "OK"
	static let connectToWifiResultCancelAction: String = "Cancel"
}
