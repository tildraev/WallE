//
//  RoverImage.swift
//  WallE
//
//  Created by Arian Mohajer on 2/5/22.
//

import Foundation

class RoverImage {
    var nameOfCamera: String
    var imageSource: String
    
    init? (dictionary: [String:Any]) {
        guard let imageSource = dictionary["img_src"] as? String else { return nil }
        
        guard let cameraDetailsDictionary = dictionary["camera"] as? [String:Any] else { return nil }
        
        guard let nameOfCamera = cameraDetailsDictionary["name"] as? String else { return nil }
        
        self.imageSource = imageSource
        self.nameOfCamera = nameOfCamera
    }
}
