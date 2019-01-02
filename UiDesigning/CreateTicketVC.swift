//
//  CreateTicketVC.swift
//  UiDesigning
//
//  Created by Jayaram G on 31/12/18.
//  Copyright © 2018 Jayaram G. All rights reserved.
//

import UIKit

class CreateTicketVC: UITableViewController {
 
    @IBOutlet weak var DatePick: UIDatePicker!
    
  
    
    @IBOutlet weak var createTktOutlet: UIButton!
    @IBAction func createTktAction(_ sender: UIButton) {
    }
    @IBOutlet var sampleTableView: UITableView!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        sampleTableView.separatorColor = UIColor.clear
        createTktOutlet.layer.cornerRadius = 20
        createTktOutlet.layer.borderColor = UIColor.white.cgColor
        createTktOutlet.layer.borderWidth = 2.0
        createTktOutlet.clipsToBounds = true
            self.perform(#selector(self.EndRefreshing), with: self, afterDelay: 5.0)
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

    
    @IBAction func ChoosingDate(_ sender: UIDatePicker) {
        
        let choosendate:Date = sender.date
        
        let dateFormatter:DateFormatter = DateFormatter.init()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let datestr = dateFormatter.string(from: choosendate)
        
        // update it on the UI
        DatePick.text = datestr
        
        
        
        
    }

    



















}
