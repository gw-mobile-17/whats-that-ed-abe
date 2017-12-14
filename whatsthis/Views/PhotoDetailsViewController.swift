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
    
    // MARK: Properties
    var image : UIImage?
    var imageString : String?
    var data : LabelAnnotations?
    var photo : PhotoModel?
    var wiki : WikipediaResult?
    var lat : Double = 200
    var lon : Double = 200
    let wikiManager = WikipediaAPIManager()
    var dataLoaded = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var wikiBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.sharedInstance.delegate = self
        LocationManager.sharedInstance.findLocation()

        wikiManager.delegate = self
        if(!self.dataLoaded){
            self.setupVCForData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!self.dataLoaded){
            self.setupVCForData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Setup View for data
    func setupVCForData(){
        // Sets up photo details
        if(photo != nil){
            // Setup using PhotoModel i.e. already favorited
            self.favBtn.isSelected = true
            titleLabel.text = photo?.text.capitalized
            imageView.image = UIImage().imageFromBase64String(base64String: (photo?.imageString)!)
            wikiManager.getWikiForString(searchString: (photo?.text)!)
            self.dataLoaded = true
        }else if(data != nil){
            // Setup using PhotoModel i.e. already favorited
            imageView.image = image
            titleLabel.text = data?.description.capitalized
            self.favBtn.isSelected = false
            wikiManager.getWikiForString(searchString: (data?.description)!)
            self.dataLoaded = true
        }
    }
    
    // MARK: Button Actions
    @IBAction func twitterBtnAction(_ sender: Any) {
        // Opens Twitter Timeline Feed of title search
        let twitterVC: TwitterTableViewController = TwitterTableViewController(searchString: titleLabel.text!)
        self.navigationController?.pushViewController(twitterVC, animated: true)
    }
    
    @IBAction func wikiBtnAction(_ sender: Any) {
        // Opens Wikipedia Page of title in SafariViewController
        let pageId : Int = (self.wiki?.query.pages.first?.value.pageid)!
        let urlString = "\(WIKI_URL)\(pageId)"
        let safarVC: SFSafariViewController = SFSafariViewController(url: URL(string: urlString)!)
        self.navigationController?.pushViewController(safarVC, animated: true)
    }
    
    @IBAction func shareBtnAction(_ sender: Any) {
        // Shares Title of Image and Wiki Extract
        let title : String = (titleLabel.text?.uppercased())!
        let description : String = textView.text
        let activityVC = UIActivityViewController(activityItems: ["\(title)\n\(description)"], applicationActivities: nil)
        self.navigationController?.present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func favBtnAction(_ sender: Any) {
        if(self.favBtn.isSelected){
            // Removes photo as favorite
            PersistanceManager().removePhoto(photo!)
        }else{
            // Favorites photo with id as current time
            let id = Date().timeIntervalSince1970
            if (photo == nil) {
                photo = PhotoModel(text: (self.data?.description)!, imageString: self.imageString!, id: id, lat: self.lat, lon: self.lon)
            }
            PersistanceManager().savePhoto(photo!)
        }
        self.favBtn.isSelected = !self.favBtn.isSelected
    }
}
extension PhotoDetailsViewController: WikipediaDelegate, LocationManagerDelegate {
    // MARK: WikipediaDelegate Methods
    func WikipediaRequestFailed(error: WikipediaAPIManager.FailureReason) {
        // Throws Alert for request failure
        weak var weakSelf = self
        let alert = UIAlertController(title: "Request Error", message: error.rawValue, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        DispatchQueue.main.async {
            weakSelf?.present(alert, animated: true)
        }}
    
    func WikipediaRequestCompleted(result: WikipediaResult) {
        weak var weakSelf = self
        // Updates viewcontroller with wikipedia text extract
        DispatchQueue.main.async {
            weakSelf?.wiki = result
            weakSelf?.textView.text = result.query.pages.first?.value.extract
        }
    }
    
    // MARK: LocationManagerDelegate Methods
    func locationFound(latitude: Double, longitude: Double) {
        self.lat = latitude
        self.lon = longitude
    }
    
    func locationNotFound(reason: LocationFailureReason) {
        // Nothing done. Might be required in future
    }
}
