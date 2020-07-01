//
//  ViewController.swift
//  MediaCaptureDemo
//
//  Created by admin on 27/03/2020.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
    var point = CGPoint()
    
    @IBOutlet weak var imageTextField: UITextField!
    
    @IBOutlet weak var saveTextBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageTextField.isHidden = true
        saveTextBtn.isHidden = true
        
        let imageViewTapped = UILongPressGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
        imageView.isUserInteractionEnabled = true
        imageViewTapped.numberOfTouchesRequired = 1
        imageViewTapped.delegate = self as? UIGestureRecognizerDelegate
        imageView.addGestureRecognizer(imageViewTapped)
        imagePicker.delegate = self
        imageTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func tapAction(_ sender: UIGestureRecognizer) {
        
        if sender.state == .ended{
            imageTextField.isHidden = false
            saveTextBtn.isHidden = false
            point = sender.location(in: self.imageView)
            print("x \(point.x) y \(point.y) ")
            
            
           
        }

    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    
    
    
    @IBAction func saveTextBtn(_ sender: Any) {
        textToImage(text: imageTextField.text! as NSString, point:   CGPoint(x: point.x, y: point.y))
        imageTextField.text = ""
        imageTextField.isHidden = true
        saveTextBtn.isHidden = true
        textFieldShouldReturn(imageTextField)
        guard let image = imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    
    @IBAction func photosBtnPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func videoBtnPressed(_ sender: Any) {
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.videoQuality = .typeMedium
        launchCamera()
    }
    
    fileprivate func launchCamera(){
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = true
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func cameraBtnPressed(_ sender: UIButton) {
        launchCamera()
    
    }
    
    func textToImage(text: NSString, point: CGPoint) {
        let lblNew = UILabel()
        lblNew.frame = CGRect(x: point.x, y: point.y, width: 200.0, height: 40)
        lblNew.textAlignment = .left
        lblNew.text = text as String
        lblNew.textColor = UIColor.white
        imageView.addSubview(lblNew)
       
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let url = info[.mediaURL] as? URL {
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
            }
            
            } else {
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            imageView.image = image
            }
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    var startPoint = CGFloat(0)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let p = touches.first?.location(in: view){
            startPoint = p.x
            
           
        }
        print("Touch began")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let p = touches.first?.location(in: view){
            print("moved to \(p)")
            //get the difference from your finger
            let diff = p.x - startPoint
            imageView.transform = CGAffineTransform(translationX: diff,y: 0)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

