//
//  PhotoDetails ViewController PhotoDetailsViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 11/11/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit
import SafariServices

class PhotoDetailsViewController: UIViewController{
    
    var image : UIImage?
    var imageString : String?
    var data : LabelAnnotations?
    var photo : PhotoModel?
    var wiki : WikipediaResult?
    var lat : Double = 200
    var lon : Double = 200
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var wikiBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.findLocation()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
        titleLabel.text = data?.description.capitalized
        let wikiManager = WikipediaAPIManager()
        wikiManager.delegate = self
        if(photo != nil){
            self.favBtn.isSelected = true
            titleLabel.text = photo?.text.capitalized
            imageView.image = UIImage().imageFromBase64String(base64String: (photo?.imageString)!)
            wikiManager.getWikiURLForString(searchString: (photo?.text)!)
        }else{
            self.favBtn.isSelected = false
            wikiManager.getWikiURLForString(searchString: (data?.description)!)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func twitterBtnAction(_ sender: Any) {
        let twitterVC: TwitterTableViewController = TwitterTableViewController(searchString: titleLabel.text!)
        self.navigationController?.pushViewController(twitterVC, animated: true)
    }
    
    @IBAction func wikiBtnAction(_ sender: Any) {
        let pageId : Int = (self.wiki?.query.pages.first?.value.pageid)!
        let urlString = "\(WIKI_URL)\(pageId)"
        let safarVC: SFSafariViewController = SFSafariViewController(url: URL(string: urlString)!)
        self.navigationController?.pushViewController(safarVC, animated: true)
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        let title : String = (titleLabel.text?.uppercased())!
        let description : String = textView.text
        let activityVC = UIActivityViewController(activityItems: ["\(title)\n\(description)"], applicationActivities: nil)
        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func favBtnAction(_ sender: Any) {
        if(self.favBtn.isSelected){
            PersistanceManager().removePhoto(photo!)
            self.photo = nil
        }else{
            let id = Date().timeIntervalSince1970
            self.photo = PhotoModel(text: (self.data?.description)!, imageString: self.imageString!, id: id, lat: self.lat, lon: self.lon)
            PersistanceManager().savePhoto(photo!)
        }
        self.favBtn.isSelected = !self.favBtn.isSelected
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
extension PhotoDetailsViewController: WikipediaDelegate, LocationManagerDelegate {
    
    func WikipediaRequestFailed(error: WikipediaAPIManager.FailureReason) {
        weak var weakSelf = self
        let alert = UIAlertController(title: "Request Error", message: error.rawValue, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            weakSelf?.present(alert, animated: true)
        }}
    
    func WikipediaRequestCompleted(result: WikipediaResult) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.wiki = result
            weakSelf?.textView.text = result.query.pages.first?.value.extract
        }
    }
    
    func locationFound(latitude: Double, longitude: Double) {
        self.lat = latitude
        self.lon = longitude
    }
    
    func locationNotFound(reason: LocationFailureReason) {
    }
}
