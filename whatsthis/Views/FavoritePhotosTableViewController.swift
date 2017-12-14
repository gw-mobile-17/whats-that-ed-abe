//
//  FavoritePhotos FavoritePhotos FavoritePhotos FavoritePhotosTableViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 11/11/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit

class FavoritePhotosTableViewController: UITableViewController {
    
    // MARK: Properties
    var data : [PhotoModel]?
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting Map Button to navigation item
        let mapBtn = UIBarButtonItem(image: UIImage(named: "Fav"),
                                           style: UIBarButtonItemStyle.plain,
                                           target: self,
                                           action: #selector(mapClicked))
        self.navigationItem.rightBarButtonItem = mapBtn
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Fetching favorite photos using PersistanceManager
        data = PersistanceManager().fetchPhotos()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - TableViewDataSource and TableViewDelegate Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : FavoriteTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FavCell") as! FavoriteTableViewCell
        cell.photoImageView?.image = UIImage().imageFromBase64String(base64String: data![indexPath.row].imageString)
        cell.tagLabel?.text = data![indexPath.row].text.capitalized
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open PhotoDetailsViewController with photo and tag
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "photoDetailVC"))!
        let photoDetailVC : PhotoDetailsViewController = vc as! PhotoDetailsViewController
        photoDetailVC.photo = self.data?[indexPath.row]
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: Button Action
    @objc func mapClicked() {
        // Opens FavoritesMapViewController with pins dropped at all locations where photo was analyzed
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "favMapVC"))!
        let favMapVC : FavoritesMapViewController = vc as! FavoritesMapViewController
        favMapVC.photos = self.data
        self.navigationController?.pushViewController(favMapVC, animated: true)
    }

}
