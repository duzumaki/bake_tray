//
//  ViewController.swift
//  bread_batch
//
//  Created by David Uzumaki on 01/03/2020.
//  Copyright © 2020 David Uzumaki. All rights reserved.
//

import UIKit
import SwiftUI

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate {
    
//    MainImage = the graphic Niall provided.
//    contentImage = the UIImageView where a photo wil be added to
    @IBOutlet weak var mainImageArea: UIImageView!
    @IBOutlet weak var contentImageArea: UIImageView!
    let imagePicker = UIImagePickerController()
    
 
//    Probably a temporary image button I'm using to test uploading to the contenImage view
    @IBAction func addImageButton(_ sender: UIButton) {
       imagePicker.allowsEditing = true
       imagePicker.sourceType = .photoLibrary

       present(imagePicker, animated: true, completion: nil)
    }
    
//  The "main" if you will. Like a python main
    override func viewDidLoad() {
        super.viewDidLoad()
        mainImageArea.image = UIImage(named: "main2000.png")
        
        contentImageArea.layer.zPosition = 0
        mainImageArea.layer.zPosition = 1
        
        //Allow the image added to be replaced.
        contentImageArea.isUserInteractionEnabled = true
        let contentImageAreaLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.replaceEditDeleteLongPressContentImage))
        
        contentImageArea.addGestureRecognizer(contentImageAreaLongPress)
        
//        The image picker needs to be made the first responder
        imagePicker.delegate = self
        
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
//    Show "crop, replace, delete" menu when long pressing image
    @objc func replaceEditDeleteLongPressContentImage(sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            let menu = UIMenuController.shared
            becomeFirstResponder()
            
            let menuItemCrop = UIMenuItem(title: "crop", action: #selector(handleMenuItemAction))
            let menuItemReplace = UIMenuItem(title: "replace", action: #selector(handleMenuItemAction))
            let menuItemDelete = UIMenuItem(title: "delete", action: #selector(handleMenuItemAction))
            menu.menuItems = [menuItemCrop,menuItemReplace,menuItemDelete]
            
//       Show this menu at the x,y coordinate of the long press.
            let location = sender.location(in: sender.view)
            let menuLocation = CGRect(x: location.x, y:location.y, width: 0, height: 0)
            menu.showMenu(from: sender.view!, rect: menuLocation)
        }
    }
    
    // TODO: three functions to handle the menu actions, namedly appropriately.
    @objc func handleMenuItemAction(){
        print("Menu Item tapped")

    }
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            contentImageArea.contentMode = .scaleToFill
            contentImageArea.image       = pickedImage
            
        } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contentImageArea.contentMode = .scaleToFill
            contentImageArea.image       = pickedImage
        }
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

struct ViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
