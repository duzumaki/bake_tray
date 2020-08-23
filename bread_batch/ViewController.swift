//
//  ViewController.swift
//  bread_batch
//
//  Created by David Uzumaki on 01/03/2020.
//  Copyright © 2020 David Uzumaki. All rights reserved.
//

import UIKit
import SwiftUI
import BSImagePicker
import Photos



class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //    MainImage = the graphic Niall provided.
//    contentImage = the UIImageView where a photo wil be added to
    @IBOutlet weak var mainImageArea: UIImageView!
    @IBOutlet weak var contentImageArea: UIImageView!
    @IBOutlet var blackTop: UIImageView!
    @IBOutlet var blackBottom: UIImageView!
    @IBOutlet var addButton: UIButton!
    
    let imagePicker = UIImagePickerController()
    @IBOutlet var test: UIButton!
    var selectedAssets = [PHAsset]()
    var PhotoArray = [UIImage]()
    
     @IBOutlet weak var userSelectedImagesCollectionView: UICollectionView!
     var userSelectedImagesCollectionViewFlowLayout: UICollectionViewFlowLayout!
    
    //return the count of the selected images from the photo album
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoArray.count
    }
    
    //Assign the UIimageView in the cell the selected photo in the photos album
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.imageOneView.image = PhotoArray[indexPath.item]
        
        return cell
    }
    
    private func setupCollectionView(){
        userSelectedImagesCollectionView.dataSource = self
        userSelectedImagesCollectionView.delegate = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupCollectionViewCellPositioningAndSizing()
    }
    
    //Setting it so there's only 3 images in the collection view evenly spaced from each other
    private func setupCollectionViewCellPositioningAndSizing(){
        if userSelectedImagesCollectionViewFlowLayout == nil {
            let numberOfItemsPerRow: CGFloat = 3
            let lineSpacing: CGFloat = 0
            let interItemSpacing: CGFloat = 0
            
            let width = (userSelectedImagesCollectionView.frame.width-(numberOfItemsPerRow - 1)*lineSpacing)/numberOfItemsPerRow
            let height = width
            
            userSelectedImagesCollectionViewFlowLayout = UICollectionViewFlowLayout()
            userSelectedImagesCollectionViewFlowLayout.itemSize = CGSize(width: width, height: height)
            userSelectedImagesCollectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
            userSelectedImagesCollectionViewFlowLayout.scrollDirection = .horizontal
            userSelectedImagesCollectionViewFlowLayout.minimumLineSpacing = lineSpacing
            userSelectedImagesCollectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
            userSelectedImagesCollectionView.setCollectionViewLayout(userSelectedImagesCollectionViewFlowLayout, animated: true)
        }
        
    }
    
    //Button to gather all images and videos into one PHAssets array.
    @IBAction func addTestImageButton(testButton sender: UIButton){
        let multiImagePicker = ImagePickerController()
        multiImagePicker.settings.selection.max = 5
        multiImagePicker.settings.theme.selectionStyle = .numbered
        multiImagePicker.settings.fetch.assets.supportedMediaTypes = [.image, .video]
        multiImagePicker.settings.selection.unselectOnReachingMax = true
       
        presentImagePicker(multiImagePicker,animated: true, select: { (asset) in
            //print("Selected: \(asset)")
        }, deselect: { (asset) in
           // print("Selected: \(asset)")
        }, cancel: { (assets) in
            //print("Selected: \(assets)")
        }, finish: { (assets) in
            for i in 0..<assets.count
            {
                self.selectedAssets.append(assets[i])
            }
            self.convertPHAssetsToUIImages()
        })
    }
    
    
    //function to convert PHAssets into array of images and(or) videos
    @objc func convertPHAssetsToUIImages(){
        if selectedAssets.count != 0 {
            for i in 0..<selectedAssets.count{
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                var thumbnail = UIImage()
                options.isSynchronous = true
                options.version = .original
                manager.requestImage(for: selectedAssets[i],
                                     targetSize: PHImageManagerMaximumSize,
                                     contentMode: .aspectFill,
                                     options: options,
                                     resultHandler: { (result, info) in
                    thumbnail = result!
                })
                self.PhotoArray.append(thumbnail)
            }
        }
       userSelectedImagesCollectionView.reloadData()
    }
 
//    Probably a temporary image button I'm using to test uploading to the contenImage view
    @IBAction func addImageButton(_ sender: UIButton) {
       imagePicker.allowsEditing = true
       imagePicker.sourceType = .photoLibrary

       present(imagePicker, animated: true, completion: nil)
    }
    
    
    
//    TODO: pass in the uiimageview as a parameter to allow the function to used more than once.
    @objc func handlePan(gesture: UIPanGestureRecognizer){
        guard gesture.view != nil else { return }
    
        if gesture.state == .began || gesture.state == .changed {
            let translation = gesture.translation(in: self.view)
            gesture.view!.center = CGPoint(x: gesture.view!.center.x + translation.x, y:gesture.view!.center.y + translation.y)
            gesture.setTranslation(CGPoint.zero, in: self.view)
        }
    }
    
    
    @objc func handlePinch(gesture: UIPinchGestureRecognizer){
        guard gesture.view != nil else { return }
        
        if let view = gesture.view {
            view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            gesture.scale = 1.0
        }
    }
    
    @objc func handleRotate(gesture: UIRotationGestureRecognizer){
        if let view = gesture.view {
            view.transform = view.transform.rotated(by: gesture.rotation)
            gesture.rotation = 0
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        self.mainImageArea.image = #imageLiteral(resourceName: "main2000")
        contentImageArea.layer.zPosition = 0
        mainImageArea.layer.zPosition = 1
        blackTop.layer.zPosition = 1
        blackBottom.layer.zPosition = 1
        addButton.layer.zPosition = 3
        test.layer.zPosition = 3
        userSelectedImagesCollectionView.layer.zPosition = 3
        contentImageArea.isUserInteractionEnabled = true
        contentImageArea.isMultipleTouchEnabled = true
        
        
        
        //add long press menu function
        let contentImageAreaLongPress = UILongPressGestureRecognizer(target: self, action: #selector(self.replaceEditDeleteLongPressContentImage))
        contentImageArea.addGestureRecognizer(contentImageAreaLongPress)
        
        
        //add pan gesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(gesture:)))
        self.view.addSubview(contentImageArea)
        panGesture.delegate = self
        contentImageArea.addGestureRecognizer(panGesture)
        
        //add pinch gesture
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(gesture:)))
        pinchGesture.delegate = self
        contentImageArea.addGestureRecognizer(pinchGesture)
        
        //add rotation gesture
        let rotationGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(self.handleRotate(gesture:)))
        rotationGesture.delegate = self
        contentImageArea.addGestureRecognizer(rotationGesture)
        
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

//#if DEBUG
//struct BreadBatchPhotoshopGraphicView_Previews: PreviewProvider {
//    static var previews: some View: some View {
//        BreadBatchPhotoshopGraphicView()
//    }
//}
//#endif
