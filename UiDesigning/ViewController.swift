//
//  ViewController.swift
//  UiDesigning
//
//  Created by Jayaram G on 31/12/18.
//  Copyright © 2018 Jayaram G. All rights reserved.
//

import UIKit
import AssetsLibrary
import PhotosUI
class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var mime:String?
    @IBOutlet weak var ImageView: UIImageView!
  
    @IBAction func ReplyAct(_ sender: UIButton) {
        ApiCallForTicketReply()
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        freshToken()
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
   
      var FileName:String?
    
    var imageData:Data?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        

        pickedImage  = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        //nsdata
        imageData  = pickedImage!.pngData() as! Data
  //      print(imageData)
     

        //base64 encoded data
        let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
    //    print(strBase64)
        
        //file size
         print(ByteCountFormatter().string(fromByteCount: Int64(strBase64.count)))
       //  print("size is : \(strBase64)")
        
    //    let imageUrl = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL
       // print(imageUrl)
      
        let imageURL:NSURL = (info[UIImagePickerController.InfoKey.referenceURL] as? NSURL)!
        print(imageURL)
        
        
//        ALAssetsLibrary().asset(for: imageURL as URL, resultBlock: { asset in
//
//            let fileName = asset?.defaultRepresentation().filename()
//            //do whatever with your file name
//            print("File name is : \(fileName ?? "none")")
//
//        }, failureBlock: nil)
    
    
             let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL as URL], options: nil)
            let asset = result.firstObject
        FileName = asset?.value(forKey: "filename") as? String

        print(FileName!)
        
        if  FileName!.hasSuffix("JPG") || FileName!.hasSuffix("jpg") {
            print("Jpg image ")
            
            mime = "image/jpg"
            
        }else if FileName!.hasSuffix("JPEG") || FileName!.hasSuffix("jpeg"){
            print("Jpeg Image ")
            mime = "image/jpeg"
            
            
        }else if FileName!.hasSuffix("PNG") || FileName!.hasSuffix("png"){
            print("this is PNG image ")
            mime = "image/png"
            
        }
        
        
        
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
   
    func ApiCallForTicketReply(){
        
        
             let id:Int = 50
        let replyContent:String = "This is sample reply"
        let Token1: String? = UserDefaults.standard.string(forKey: "TokenKey") ?? ""
    
        let params: [String: Any] = ["ticket_id" : id, "reply_content" : replyContent]
        print(Token1!)
        var urlStr:String = "http://faveo-mobileapps.tk/servicefinal/public/api/v1/helpdesk/reply?token="
        urlStr.append(Token1!)
        print(urlStr)

        var request  = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        
        
        let boundary = "---------------------------14737809831466499882746641449"

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = NSMutableData()
        let fname = FileName
        let mimetype = mime
        
        //define the data post parameter
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"media_attachment[]\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData!)
      
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
//        body.append("hi\r\n".data(using: String.Encoding.utf8)!)
//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//
//        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//
        
        request.httpBody = body as Data
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("token", forHTTPHeaderField: "Authorization")
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }catch let error{
            print("params boday error \(error)")
        };
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let jsonData = data, let lResponse  = response as? HTTPURLResponse{
                
                do {
                    print("status code \(lResponse.statusCode)")
                    
                    
                    var userData = try JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves)as! [String:Any]
                    
                    print(userData)
                    let message = userData["message"] as? String
                    if message == "Token not provided"   {
                        print("refreshing Token ")
                        freshToken()
                    }else{
                        print("tokent resfreshed")
                    }
                
                    
                    
                }
            catch var err {
                    print(err.localizedDescription)
                }
            }
            }.resume()
}
}
