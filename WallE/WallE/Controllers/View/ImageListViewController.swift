//
//  ImageListViewController.swift
//  WallE
//
//  Created by Arian Mohajer on 2/5/22.
//

import UIKit

class ImageListViewController: UIViewController {

    var rover: Rover?
    var images: [RoverImage]?
    @IBOutlet weak var roverImageTableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roverImageTableView.delegate = self
        roverImageTableView.dataSource = self
        
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        
        guard let rover = rover else { return }
        NetworkController.fetchImagesFromDate(roverName: rover.name, date: self.datePicker.date) { images in
            self.images = images
            
            DispatchQueue.main.async {
                self.roverImageTableView.reloadData()
            }
        }
    }
    

}

extension ImageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let images = images else { return 0 }
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell() }
        
        if let images = images {
            cell.cameraNameLabel.text = images[indexPath.row].nameOfCamera
        }
        
        return cell
        
    }
}
