//
//  Rover.swift
//  WallE
//
//  Created by Arian Mohajer on 2/5/22.
//

import Foundation

class Rover {
    var name: String
    var cameras: [String]
    var launchDate: Date
    var maxDate: Date
    
    init? (dictionary: [String:Any]) {
        
        guard let name = dictionary["name"] as? String,
              let cameras = dictionary["cameras"] as? [[String:Any]],
              let launchDate = dictionary["launch_date"] as? String,
              let maxDate = dictionary["max_date"] as? String else { return nil }
        
        self.name = name
        
        var cameraList: [String] = []
        
        for cameraDictionary in cameras {
            guard let cameraName = cameraDictionary["name"] as? String else { return nil }
            cameraList.append(cameraName)
        }
        
        self.cameras = cameraList
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let launchDateFormatted = dateFormatter.date(from: launchDate),
              let maxDateFormatted = dateFormatter.date(from: maxDate) else { return nil }
        
        self.launchDate = launchDateFormatted
        self.maxDate = maxDateFormatted
    }
}
