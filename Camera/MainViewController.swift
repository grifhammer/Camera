//
//  MainViewController.swift
//  Camera
//
//  Created by Griffin Hammer on 12/2/15.
//  Copyright © 2015 Griffin Hammer. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {

    private var currentZoom: CGFloat = 1.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBAction func actionButtonTouched(sender: AnyObject) {
        if let image = self.displayImageView.image{
            //Add Code Here
            let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityViewController.excludedActivityTypes = [UIActivityTypeMail];
            
            self.presentViewController(activityViewController, animated: true, completion: nil)
            
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
        
        self.scrollView.addGestureRecognizer(gesture)
        
        self.scrollView.delegate = self
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

}
