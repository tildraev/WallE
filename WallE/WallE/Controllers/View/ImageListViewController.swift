//
//  ImageListViewController.swift
//  WallE
//
//  Created by Arian Mohajer on 2/5/22.
//

import UIKit

class ImageListViewController: UIViewController {

    var arrayOfRoverImage: [RoverImage]?
    var rover: Rover?
    
    @IBOutlet weak var roverImageTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roverImageTableView.delegate = self
        roverImageTableView.dataSource = self
        if let rover = rover  {
            datePicker.date = rover.launchDate
        }

    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        
        guard let rover = rover else { return }
        NetworkController.fetchImagesFromDate(roverName: rover.name, date: self.datePicker.date) { images in
            
            guard let images = images else { return }
            
            self.arrayOfRoverImage = images
            
            DispatchQueue.main.async {
                self.roverImageTableView.reloadData()
            }
        }
    }
}

extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let images = arrayOfRoverImage else { return 0 }
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
        
        if let images = arrayOfRoverImage {
            cell.cameraNameLabel.text = images[indexPath.row].nameOfCamera
            if rover?.name == "Curiosity" || rover?.name == "Spirit" || rover?.name == "Opportunity" {
                var secureSource = images[indexPath.row].imageSource
                let index = secureSource.index(secureSource.startIndex, offsetBy: 4)
                secureSource.insert("s", at: index)
                
                NetworkController.fetchImage(imageSource: secureSource) { finalImage in
                    DispatchQueue.main.async {
                        cell.roverImageView.image = finalImage
                    }
                }
            } else {
                NetworkController.fetchImage(imageSource: images[indexPath.row].imageSource) { finalImage in
                    DispatchQueue.main.async {
                        cell.roverImageView.image = finalImage
                    }
                }
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}
