//
//  ViewController.swift
//  bread_batch
//
//  Created by David Uzumaki on 01/03/2020.
//  Copyright © 2020 David Uzumaki. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet var mainImageArea: UIImageView!
    
    let imagePicker = UIImagePickerController()
    

    @IBAction func addImageButton(_ sender: UIButton) {
           imagePicker.allowsEditing = false
           imagePicker.sourceType = .photoLibrary
           
           present(imagePicker, animated: true, completion: nil)
       }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mainImageArea.contentMode = .scaleAspectFit
            mainImageArea.image       = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

