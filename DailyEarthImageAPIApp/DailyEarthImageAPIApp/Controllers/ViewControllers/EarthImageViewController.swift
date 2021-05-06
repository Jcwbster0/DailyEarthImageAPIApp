//
//  EarthImageViewController.swift
//  DailyEarthImageAPIApp
//
//  Created by Justin Webster on 5/5/21.
//

import UIKit

class EarthImageViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var earthCaptionLabel: UILabel!
    @IBOutlet weak var earthDateLabel: UILabel!
    @IBOutlet weak var earthImageview: UIImageView!
    
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewsForEarthImage()
    }
    
    //MARK: - Properties
    var earthImage: EarthImage?
    
    //MARK: - Functions
    
    func updateViewsForEarthImage () {
        guard let earthImage = earthImage else {return}
        EarthImageController.fetchImage(earthImage: earthImage) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.earthImageview.image = image
                    self.earthCaptionLabel.text = earthImage.caption
                    self.earthDateLabel.text = earthImage.date
                case .failure(let error):
                    print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                }
            }
        }
    }
}//End of Class
