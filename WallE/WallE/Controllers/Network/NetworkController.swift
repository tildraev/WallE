//
//  NetworkController.swift
//  WallE
//
//  Created by Arian Mohajer on 2/5/22.
//

import Foundation
import UIKit

class NetworkController {
    private static let baseURL = "https://api.nasa.gov"
    private static let apiKey = "EI72C9focuh7K2FaxjdT9Uw5cS1lZg1sXpgfATjP"
    
    static func fetchRovers(completion: @escaping ([Rover]?) -> Void) {
        guard let baseURL = URL(string: baseURL) else {
            print("Unable to convert from baseURL string to URL")
            completion(nil)
            return
        }
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            print("Unable to convert from baseURL To URLComponent")
            completion(nil)
            return
        }
        
        urlComponents.path = "/mars-photos/api/v1/rovers"
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        urlComponents.queryItems = [apiKeyQuery]
        
        guard let finalURL = urlComponents.url else {
            print("unable to create final URL from urlComponents: \(urlComponents.description)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error with dataTask. ", error)
                completion(nil)
            }
            
            guard let data = data else {
                print(finalURL)
                print("Error retrieving data")
                completion(nil)
                return
            }
            
            do {
                if let topLevelDictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any] {
                    
                    guard let roverList = topLevelDictionary["rovers"] as? [[String:Any]] else {
                        print(finalURL)
                        print("Error unwrapping top level dictionary")
                        completion(nil)
                        return
                    }
                    
                    var listOfRovers: [Rover] = []
                    
                    for roverDictionary in roverList {
                        if let roverToAdd = Rover(dictionary: roverDictionary) {
                            listOfRovers.append(roverToAdd)
                        }
                    }
                    
                    completion(listOfRovers)
                    
                }
                
            } catch {
                print("Error in do/catch block. ", error)
            }
        }.resume()
    }
    
    static func fetchImagesFromDate(roverName: String, date: Date, completion: @escaping ([RoverImage]?) -> Void) {
        
        guard let baseURL = URL(string: baseURL) else {
            print("unable to convert from baseURL string to URL")
            completion(nil)
            return
        }
        
        guard var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            print("Unable to convert from baseURL to URLComponents")
            completion(nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        urlComponents.path = "/mars-photos/api/v1/rovers/\(roverName)/photos"
        let dateQuery = URLQueryItem(name: "earth_date", value: dateFormatter.string(from: date))
        let apiKeyQuery = URLQueryItem(name: "api_key", value: apiKey)
        
        urlComponents.queryItems = [dateQuery, apiKeyQuery]
        
        guard let finalURL = urlComponents.url else {
            print("Unable to create finalURL from urlComponents: \(urlComponents.url)")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error while fetching data from: \(finalURL)", error)
                completion(nil)
            }
            
            guard let data = data else {
                print("Error with data: \(data)")
                completion(nil)
                return
            }
            
            do {
                if let topLevelDictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String:Any] {
                    
                    guard let photosArray = topLevelDictionary["photos"] as? [[String:Any]] else { return }
                    
                    var photosToReturn: [RoverImage] = []
                    
                    for photo in photosArray {
                        guard let photoToAdd = RoverImage(dictionary: photo) else { return }
                        photosToReturn.append(photoToAdd)
                    }
                    
                    completion(photosToReturn)
                }
            } catch {
                print(error)
            }
        }.resume()
        
    }
    
    static func fetchImage(imageSource: String, completion: @escaping (UIImage?) -> Void) {
        
//        var secureSource = imageSource
//        let index = secureSource.index(secureSource.startIndex, offsetBy: 4)
//        secureSource.insert("s", at: index)
        
        guard let imageURL = URL(string: imageSource) else {
            print("could not make a valid URL from source: \(imageSource)")
            completion(nil)
            return
        }
        
        
        
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let error = error {
                print("Error starting datatask from url: \(imageURL)", error)
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Invalid data: \(data)")
                completion(nil)
                return
            }
            
            let imageToReturn = UIImage(data: data)
            completion(imageToReturn)
            
        }.resume()
    }
}
