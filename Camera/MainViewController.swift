//
//  MainViewController.swift
//  Camera
//
//  Created by Griffin Hammer on 12/2/15.
//  Copyright © 2015 Griffin Hammer. All rights reserved.
//

import UIKit
import FBSDKShareKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, FBSDKSharingDelegate {

    private var currentZoom: CGFloat = 1.0
    private var imageStore : [UIImage]!
    
    @IBOutlet weak var previewCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var displayImageView: UIImageView!
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        
    }
    
    @IBAction func actionButtonTouched(sender: AnyObject) {
        if let image = self.displayImageView.image {
            let sharePhoto = FBSDKSharePhoto(image: image, userGenerated: true)
            let content = FBSDKSharePhotoContent()
            content.photos = [sharePhoto]
            FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: self)
        }
    }
    
    func displayImagePicker(sType: UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sType
        
        imagePicker.delegate = self
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTouched(sender: AnyObject) {
        
        displayImagePicker(.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.displayImageView.image = image
        
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
       
        self.imageStore.insert(image, atIndex: 0)
        
        
        previewCollectionView.alpha = 1.0
        
        self.previewCollectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func libraryButtonTouched(sender: AnyObject) {
        displayImagePicker(.PhotoLibrary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gesture = UITapGestureRecognizer(target: self, action: "zoomImage")
        
        gesture.numberOfTapsRequired = 2
        
        self.imageStore = [UIImage]()
        
        self.scrollView.addGestureRecognizer(gesture)
        
        self.scrollView.delegate = self
        
        
        
        previewCollectionView.alpha = 0.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.displayImageView
    }
    
    
    func zoomImage(){
        
        if self.currentZoom == 1.0{
            self.currentZoom = 2.0
        }
        else {
            self.currentZoom = 1.0
        }
        UIView.animateWithDuration(0.5) { [unowned self] in
            self.scrollView.minimumZoomScale = self.currentZoom
            self.scrollView.maximumZoomScale = self.currentZoom
            self.scrollView.zoomScale = self.currentZoom
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let item = self.imageStore[indexPath.row]
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PreviewCellReuseID", forIndexPath: indexPath) as? PreviewCollectionViewCell {
            cell.previewImageView.image = item
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.imageStore.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let image = self.imageStore[indexPath.item]
        
        self.displayImageView.image = image
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FilterSegue" {
            if let vc : FilterViewController = segue.destinationViewController as? FilterViewController {
                vc.sourceImage = self.displayImageView.image
            }
        }
    }
    
    @IBAction func didSelectFilter(segue : UIStoryboardSegue) {
        if segue.identifier == "FilterSelectedSegue" {
            if let source = segue.sourceViewController as? FilterViewController,
                let image = source.filteredImage {
                    self.displayImageView.image = image
            }
        }
    }

}
