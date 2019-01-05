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
import MobileCoreServices
class ViewController: UIViewController,UIImagePickerControllerDelegate,UIDocumentPickerDelegate, UINavigationControllerDelegate {

    var mime:String?
    @IBOutlet weak var ImageView: UIImageView!
  
    @IBOutlet weak var documetLbl: UILabel!
    @IBOutlet weak var documentsizeLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
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
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: [(kUTTypeText as! NSString) as String],in: .import)
        documentPicker.delegate = self
    
        
    let actionSheet = UIAlertController.init(title: "image Sources", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController,animated: true,completion: nil)

        
        }))
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController,animated: true,completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Documents", style: .default, handler: { (action) -> Void in
       
           self.present(documentPicker,animated: true,completion: nil)
        }))
        
        
        
       
    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet,animated: true,completion: nil)
    }
    

    var nameStr:String?
    
    var pickedImage:UIImage?
   
      var FileName:String?
    
    var imageData:Data?
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print(info)
        

        pickedImage  = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageData  = pickedImage!.pngData() as! Data
        let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
         print(ByteCountFormatter().string(fromByteCount: Int64(strBase64.count)))
        let imageURL:NSURL = (info[UIImagePickerController.InfoKey.referenceURL] as? NSURL)!
        print(imageURL)
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
  
        self.ImageView.image = pickedImage
     
        picker.dismiss(animated: true, completion: nil)
  
    }
    
    var DocFileName:String?
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        print(urls)
        
        let fileName1 = urls.last
        
        let urlString = fileName1?.absoluteString
        
       documetLbl.text = urlString 
        
        
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
     
        let TicketId:Int = 50
        let Token1: String? = UserDefaults.standard.string(forKey: "TokenKey") ?? ""
        print(Token1!)
        var urlStr:String = "http://faveo-mobileapps.tk/servicefinal/public/api/v1/helpdesk/reply?token="
        urlStr.append(Token1!)
        print(urlStr)

        var request  = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = "POST"
        
        let body = NSMutableData()
        let boundary = "---------------------------14737809831466499882746641449"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let fname = FileName
        let mimetype = mime
        
        
        //define the data post parameter
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"media_attachment[]\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData!)
      
        body.append("\r\n".data(using: String.Encoding.utf8)!)

        if let data = "--\(boundary)\r\n".data(using: .utf8) {
            body.append(data)
        }
        if let data = "Content-Disposition: form-data; name=\"reply_content\"\r\n\r\n".data(using: .utf8) {
            body.append(data)
        }
        if let data = textView.text.data(using: .utf8) {
            body.append(data)
        }
       
        
        if let data = "\r\n".data(using: .utf8) {
            body.append(data)
        }
      
        if let data = "--\(boundary)\r\n".data(using: .utf8) {
            body.append(data)
        }
        if let data = "Content-Disposition: form-data; name=\"ticket_id\"\r\n\r\n".data(using: .utf8) {
            body.append(data)
        }
        if let data = String(TicketId).data(using: .utf8){
            body.append(data)
        }
        
        if let data = "\r\n".data(using: .utf8) {
            body.append(data)
        }


        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = body as Data
 
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
