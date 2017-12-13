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
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var image : UIImage?
    var data : [LabelAnnotations] = []
    var imageString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(image != nil){
            let googleVisionAPIManager = GoogleVisionAPIManager()
            googleVisionAPIManager.delegate = self
            imageString = googleVisionAPIManager.getLabelsForImage(image : image!)
        }
        // Do any additional setup after loading the view.
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension PhotoIdentificationViewController : UITableViewDataSource, UITableViewDelegate, GoogleVisionDelegate {
    
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
    
    func GoogleVisionRequestFailed(error: GoogleVisionAPIManager.FailureReason) {
        //TODO : Handle Failed Request Scenario
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
        data = result.responses[0].labelAnnotations
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.tableView.reloadData()
            MBProgressHUD.hide(for: (weakSelf?.tableView)!, animated: true)
        }
    }
}
