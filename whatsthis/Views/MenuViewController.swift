//
//  ViewController.swift
//  whatsthis
//
//  Created by Edwin Abraham on 11/11/17.
//  Copyright © 2017 Edwin Abraham. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    // MARK: Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Action Methods
    @IBAction func galleryBtnAction(_ sender: Any) {
        // Opens UIImagePickerController in gallery mode
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnAction(_ sender: Any) {
        // Opens UIImagePickerController in camera mode
        let imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension MenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        weak var weakSelf = self
        // Dismisses Picker and launches PhotoIdentificationViewController with image
        picker.dismiss(animated: true) {
            let vc : UIViewController = (weakSelf?.storyboard?.instantiateViewController(withIdentifier: "photoIDVC"))!
            let photoIDVC : PhotoIdentificationViewController = vc as! PhotoIdentificationViewController
            
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
