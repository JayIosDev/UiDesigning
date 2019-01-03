//
//  ViewController.swift
//  UiDesigning
//
//  Created by Jayaram G on 31/12/18.
//  Copyright © 2018 Jayaram G. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var ImageView: UIImageView!
  
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    @IBAction func chooseImage(_ sender: UIButton) {
    
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
    let actionSheet = UIAlertController.init(title: "image Sources", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController,animated: true,completion: nil)

        
        }))
    
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController,animated: true,completion: nil)
            
        }))
        
       
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet,animated: true,completion: nil)
    }
    
//    let imagecache = [String:UIImage]()
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//
//
//        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//
//
//        let imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL
//        let imageName = imageUrl?.path?.last
//
//
//
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String!
//        let localPath = (documentDirectory as! NSString).appendingPathComponent("\(imageName)")
//
//        let data = image.pngData()
//
//
//        let photoURL = NSURL(fileURLWithPath: localPath)
//        print(photoURL)
//
//        ImageView.image = image
//
//
//        picker.dismiss(animated: true, completion:  nil)
//    }
    
    var nameStr:String?
    
    var pickedImage:UIImage?
   // var phAsset: PHObject?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        

        pickedImage  = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //nsdata
        let imageData:NSData = pickedImage!.pngData() as! NSData
  //      print(imageData)
     

        //base64 encoded data
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
    //    print(strBase64)
        
        //file size
         print(ByteCountFormatter().string(fromByteCount: Int64(strBase64.count)))
       //  print("size is : \(strBase64)")
        
    //    let imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL
       // print(imageUrl)
      
        let imageURL = info[UIImagePickerController.InfoKey.referenceURL] as! NSURL
        
        
        //
        
        
        //let imageName = imageUrl
//        print(imageName)
//        print(imageName)
        
    
        self.ImageView.image = pickedImage
        
        
        picker.dismiss(animated: true, completion: nil)
        
        
//        print(arc4random())
//        let num:String = String(Int(arc4random()))
//        nameStr  = " " + num + ".jpg"
//        print(nameStr)
        
    }
    
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ImageSaveBtn(_ sender: UIButton) {
        
        let imageData = ImageView.image!.pngData()
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)        
        let alert = UIAlertController.init(title: "Saved", message: "Your Image has been saved Succesfully ", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
       
        self.present(alert,animated: true,completion: nil)
    }
   
 
}

extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
        ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
