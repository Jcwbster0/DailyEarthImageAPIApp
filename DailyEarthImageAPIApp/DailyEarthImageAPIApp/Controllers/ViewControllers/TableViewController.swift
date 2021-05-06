//
//  TableViewController.swift
//  DailyEarthImageAPIApp
//
//  Created by Justin Webster on 5/6/21.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImages()
    }

    //MARK: - Properties
    var images: [EarthImage] = []
    
    //MARK: -  methods
    
    func fetchImages() {
        EarthImageController.fetchEarthImageData { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self.images = images
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
        let earthImage = images[indexPath.row]
        
        cell.textLabel?.text = earthImage.date

        return cell
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageVC" {
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? EarthImageViewController else {return}
            
            let selectedImage = images[indexPath.row]
            destinationVC.earthImage = selectedImage
        }
    }
}
