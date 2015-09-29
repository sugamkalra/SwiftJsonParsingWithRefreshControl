//
//  DetailViewController.swift
//  SwiftyRefreshJson
//
//  Created by Sugam Kalra on 03/08/15.
//  Copyright (c) 2015 Sugam Kalra. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    var objCountry:Country?

    @IBOutlet weak var lblIPAddress: UILabel!
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var txtvDescription: UITextView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print(objCountry)
        
        lblIPAddress.text = objCountry?.ipAddress
        lblFirstName.text = objCountry?.firstName
        lblLastName.text = objCountry?.lastName
        lblCountry.text = objCountry?.country
        lblEmail.text = objCountry?.email
        
        print(objCountry?.detail)
        
        txtvDescription.text = objCountry?.detail

        // Do any additional setup after loading the view.
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

}
