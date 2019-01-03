//
//  CreateTicketVC.swift
//  UiDesigning
//
//  Created by Jayaram G on 31/12/18.
//  Copyright © 2018 Jayaram G. All rights reserved.
//

import UIKit

class CreateTicketVC: UITableViewController {
 
    
    
    @IBOutlet weak var ChoosingDate: UITextField!
    
    private var datePick:UIDatePicker!
    
    @IBOutlet weak var createTktOutlet: UIButton!
    @IBAction func createTktAction(_ sender: UIButton) {
    }
    @IBOutlet var sampleTableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePick = UIDatePicker()
        datePick.datePickerMode = .date
        ChoosingDate.inputView = datePick
        datePick.addTarget(self, action: #selector(CreateTicketVC.dateChanged(datePick:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        
        activityIndicator()
        sampleTableView.separatorColor = UIColor.clear
        createTktOutlet.layer.cornerRadius = 20
        createTktOutlet.layer.borderColor = UIColor.white.cgColor
        createTktOutlet.layer.borderWidth = 2.0
        createTktOutlet.clipsToBounds = true
            self.perform(#selector(self.EndRefreshing), with: self, afterDelay: 5.0)
        
        
    }

    @objc func viewTapped(gestureRecognizer:UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func dateChanged(datePick : UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        ChoosingDate.text = dateFormatter.string(from: datePick.date)
        let textFieldText = ChoosingDate.text
        print(textFieldText!)
        
    }
    @objc func EndRefreshing(){
        self.refreshControl?.endRefreshing()
    }
    
    
    
    func activityIndicator(){
        refreshControl = UIRefreshControl()
        refreshControl!.backgroundColor = UIColor.red
        refreshControl!.tintColor = UIColor.yellow
        tableView.addSubview(refreshControl!)
    }
}
