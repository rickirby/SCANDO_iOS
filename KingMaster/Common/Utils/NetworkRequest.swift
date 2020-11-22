//
//  NetworkRequest.swift
//  KingMaster
//
//  Created by Ricki Private on 22/11/20.
//  Copyright © 2020 Ricki Bin Yamin. All rights reserved.
//

import Foundation

class NetworkRequest {
	
	static func get(url: String, completionHandler: (([String: Any]) -> Void)? = nil) {
		guard let requestURL = URL(string: url) else {
			return
		}
		
		var request = URLRequest(url: requestURL)
		request.httpMethod = "GET"
		
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if let error = error {
				let errorMessage: [String: String] = ["msg": "Got error \(error)"]
				completionHandler?(errorMessage)
				return
			}
			
			if let response = response as? HTTPURLResponse {
				print("Response HTTP Status code: \(response.statusCode)")
			}
			
			
			if let data = data {
				
				do {
					if let result = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
						completionHandler?(result)
					}
				} catch let error as NSError {
					let errorMessage: [String: String] = ["msg": "Got error \(error)"]
					completionHandler?(errorMessage)
				}
			}
			
		}
		
		task.resume()
	}
	
}
