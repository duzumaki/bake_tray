//
//  ViewController.swift
//  bread_batch
//
//  Created by David Uzumaki on 01/03/2020.
//  Copyright © 2020 David Uzumaki. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var mainImageArea: UIImageView!
    @IBOutlet weak var contentImageArea: UIImageView!
    
    
    
    let imagePicker = UIImagePickerController()
    
    
    
    @IBAction func addImageButton(_ sender: UIButton) {
       imagePicker.allowsEditing = false
       imagePicker.sourceType = .photoLibrary

       contentImageArea.layer.zPosition = 0
       mainImageArea.layer.zPosition = 1
       
       present(imagePicker, animated: true, completion: nil)
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageArea.image = UIImage(named: "main2000.png")
        
        imagePicker.delegate = self
    }
  
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contentImageArea.contentMode = .scaleToFill
            contentImageArea.image       = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

