//
//  PhotoDetails ViewController PhotoDetailsViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 11/11/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit

class PhotoDetailsViewController: UIViewController{
    
    var image : UIImage?
    var data : LabelAnnotations?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var wikiBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let wikiManager = WikipediaAPIManager()
        wikiManager.delegate = self
        wikiManager.getWikiURLForString(searchString: (data?.description)!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = image
        titleLabel.text = data?.description
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func twitterBtnAction(_ sender: Any) {
    }
    @IBAction func wikiBtnAction(_ sender: Any) {
    }
    @IBAction func shareBtnAction(_ sender: Any) {
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
extension PhotoDetailsViewController: WikipediaDelegate {
    func WikipediaRequestFailed(error: Error?) {
        
    }
    func WikipediaRequestCompleted(result: WikipediaResult) {
        weak var weakSelf = self
        DispatchQueue.main.async {
            weakSelf?.textView.text = result.query.pages.first?.value.extract
        }
    }
}
