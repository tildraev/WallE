//
//  RoverListTableViewController.swift
//  WallE
//
//  Created by Arian Mohajer on 2/5/22.
//

import UIKit

class RoverListTableViewController: UITableViewController {

    var roverList: [Rover]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.fetchRovers { rovers in
            guard let roverList = rovers else { return }
            self.roverList = roverList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let roverCount = roverList?.count else {return 0}
        return roverCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "roverCell", for: indexPath)

        // Configure the cell...
        
        if let roverList = roverList {
            cell.textLabel?.text = roverList[indexPath.row].name
        }
        
        cell.selectionStyle = .none
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let roverList = roverList else { return }

        if segue.identifier == "toRoverPics" {
            if let index = tableView.indexPathForSelectedRow {
                if let destination = segue.destination as? ImageListViewController {
                    let rover = roverList[index.row]
                    destination.rover = rover
                }
            }
        }
    }
}
