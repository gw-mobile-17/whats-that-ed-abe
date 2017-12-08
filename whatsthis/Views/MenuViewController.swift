//
//  ViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 11/11/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    @IBAction func btnGalleryClicked(_ sender: Any) {
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "imagePicker"?:
            NSLog(segue.destination.description)
            let pickerController: UIImagePickerController = segue.destination as! UIImagePickerController
            pickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            break
            
        default:
            break
        }
    }
}

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        picker.dismiss(animated: true) {
            var vc : UIViewController = (weakSelf?.storyboard?.instantiateViewController(withIdentifier: "photoIDVC"))!
            var photoIDVC : PhotoIdentificationViewController = vc as! PhotoIdentificationViewController
            
            var originalImage : UIImage?
            
            originalImage = info[UIImagePickerControllerEditedImage] as? UIImage
            
            if(originalImage == nil) {
                originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            if(originalImage == nil) {
                originalImage = info[UIImagePickerControllerCropRect] as? UIImage;
            }
            
            photoIDVC.image = originalImage
            
            weakSelf?.navigationController?.pushViewController(photoIDVC, animated: true)
            
        }
    }
}
