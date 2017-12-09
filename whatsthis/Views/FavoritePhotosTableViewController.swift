//
//  FavoritePhotos FavoritePhotos FavoritePhotos FavoritePhotosTableViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 11/11/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit

class FavoritePhotosTableViewController: UITableViewController {
    var data : [PhotoModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapBtn = UIBarButtonItem(image: UIImage(named: "Fav"),
                                           style: UIBarButtonItemStyle.plain,
                                           target: self,
                                           action: #selector(mapClicked))
        self.navigationItem.rightBarButtonItem = mapBtn
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = PersistanceManager().fetchPhotos()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (data?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.imageView?.image = UIImage().imageFromBase64String(base64String: data![indexPath.row].imageString)
        cell.textLabel?.text = data![indexPath.row].text
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "photoDetailVC"))!
        let photoDetailVC : PhotoDetailsViewController = vc as! PhotoDetailsViewController
        photoDetailVC.photo = self.data?[indexPath.row]
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
    
    @objc func mapClicked() {
        let vc : UIViewController = (self.storyboard?.instantiateViewController(withIdentifier: "favMapVC"))!
        let favMapVC : FavoritesMapViewController = vc as! FavoritesMapViewController
        favMapVC.photos = self.data
        self.navigationController?.pushViewController(favMapVC, animated: true)
    }

}
