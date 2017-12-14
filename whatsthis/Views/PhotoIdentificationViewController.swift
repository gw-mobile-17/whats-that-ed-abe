//
//  PhotoIdentificationViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 11/11/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit
import MBProgressHUD

class PhotoIdentificationViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var image : UIImage?
    var data : [LabelAnnotations] = []
    var imageString : String?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // GoogleVision API requested when image is present
        if(image != nil){
            let googleVisionAPIManager = GoogleVisionAPIManager()
            googleVisionAPIManager.delegate = self
            //image string returned from GoogleVision Request is the base64 encode image string
            imageString = googleVisionAPIManager.getLabelsForImage(image : image!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
        if(data.count == 0){
            MBProgressHUD.showAdded(to: self.tableView, animated: true)
        }
        self.tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension PhotoIdentificationViewController : UITableViewDataSource, UITableViewDelegate, GoogleVisionDelegate {
    // MARK: - TableViewDataSource and TableViewDelegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row].description.capitalized
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "photoDetailVC"))!
        let photoDetailVC : PhotoDetailsViewController = vc as! PhotoDetailsViewController
        photoDetailVC.data = self.data[indexPath.row]
        photoDetailVC.image = self.image
        photoDetailVC.imageString = self.imageString
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
    //MARK: - GoogleVisionRequestDelegate Methods
    func GoogleVisionRequestFailed(error: GoogleVisionAPIManager.FailureReason) {
        // Throws Alert for request failure
        weak var weakSelf = self
        let alert = UIAlertController(title: "Request Error", message: error.rawValue, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            weakSelf?.present(alert, animated: true)
            MBProgressHUD.hide(for: (weakSelf?.tableView)!, animated: true)
        }
    }
    func GoogleVisionRequestCompleted(result: GoogleVisionResult) {
        // Updates viewcontroller with GoogleVisionRequest labels
        data = result.responses[0].labelAnnotations
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.tableView.reloadData()
            MBProgressHUD.hide(for: (weakSelf?.tableView)!, animated: true)
        }
    }
}
