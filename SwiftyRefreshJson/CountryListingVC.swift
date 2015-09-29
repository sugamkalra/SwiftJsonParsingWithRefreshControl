//
//  CountryListingVC.swift
//  SwiftyRefreshJson
//
//  Created by Sugam Kalra on 23/07/15.
//  Copyright (c) 2015 Sugam Kalra. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class CountryListingVC: UITableViewController,NSURLConnectionDelegate
{
    let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
    
    let arrPersons = NSMutableArray()
    
    var data = NSMutableData()
    
    var arrCountryData = NSMutableArray()
    
    let managedObjectContext:NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let managedObjectModel:NSManagedObjectModel = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectModel

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        self.refreshControl?.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        let arrData =  self.retrievePersonData()
        
        if arrData.count>0
        {
            //self.tableView.reloadData()
        }
        else
        {
            startConnection()
        }

        self.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        JHProgressHUD.sharedHUD.showInWindow(appDel.window!)
        
        let arrData =  self.retrievePersonData()
        
        if arrData.count>0
        {
            //self.tableView.reloadData()
        }
        else
        {
            startConnection()
        }
        
        
    }
    
    
    func startConnection(){
        let urlPath: String = "http://www.mocky.io/v2/559ea33b6384a6f41472853b"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)
        let connection: NSURLConnection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
}
    
    
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        var err: NSError
        // throwing an error on the line below (can't figure out where the error message is)
        
        
        let jsonResult: NSArray = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)) as! NSArray
        
        
        print(jsonResult)
        
        
        self.savePersonData(jsonResult);
        
        
        
        }
    
    func savePersonData(jsonResult:NSArray)
    {
        for(var i:Int = 0; i<jsonResult.count; i++)
        {
            let objCountry:Country!
            
            objCountry = NSEntityDescription.insertNewObjectForEntityForName("Country", inManagedObjectContext: managedObjectContext) as! Country
            
            let dicPerson:NSDictionary = jsonResult[i] as! NSDictionary
            
            let x:Int = (dicPerson.valueForKey("id") as? Int)!
            
            let myIdString = String(x)
            
            objCountry.id = myIdString
            
            if let firstName = dicPerson.valueForKey("first_name") as? String
            {
                objCountry.firstName = firstName;
                
            }
            if let lastName = dicPerson.valueForKey("last_name") as? String
            {
                objCountry.lastName = lastName;
                
            }
            if let email = dicPerson.valueForKey("email") as? String
            {
                objCountry.email = email;
                
            }
            if let country = dicPerson.valueForKey("country") as? String
            {
                objCountry.country = country;
                
            }
            if let ipAdd = dicPerson.valueForKey("ip_address") as? String
            {
                objCountry.ipAddress = ipAdd;
                
            }
            if let description = dicPerson.valueForKey("description") as? String
            {
                objCountry.detail = description;
                
            }
            
            
            
            
            var error:NSError
            
            do {
                try managedObjectContext.save()
            } catch _ {
            }
            
        }
        
        self.retrievePersonData()

    }
    
    func retrievePersonData() ->NSArray
    {
        let fetchRequest:NSFetchRequest = managedObjectModel.fetchRequestTemplateForName("GetAllCountry")!
        
        let country:Array<Country>? = (try? managedObjectContext.executeFetchRequest(fetchRequest)) as? [Country]
        
        self.arrPersons.removeAllObjects()
        
        self.arrPersons.addObjectsFromArray(country!)
        
        let arrCountry = NSMutableArray()
        
        for objCountry in country!
        {
            
            let dicPerson = NSMutableDictionary()
            
            print(objCountry.country)
            
            dicPerson.setValue(objCountry.country, forKey:"country")
            dicPerson.setValue(objCountry.ipAddress, forKey: "ip_address")
            
            arrCountry.addObject(dicPerson);
            
            
        }
        
        print(arrCountry);
        
        
        self.arrCountryData.removeAllObjects()
        
        self.arrCountryData = arrCountry;
        
        print(arrCountryData)
        
       
        
        self.tableView.reloadData()
        
        JHProgressHUD.sharedHUD.hide()
        
        return self.arrCountryData
        

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1;
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return self.arrCountryData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellCity", forIndexPath: indexPath) 
        
        // Configure the cell...
        
        var lblCountryName:UILabel = cell.viewWithTag(1) as! UILabel
        var lbliPAddress:UILabel = cell.viewWithTag(2) as! UILabel
        var imgvImage:UIImageView = cell.viewWithTag(3) as! UIImageView
        
        let objBook:NSDictionary = self.arrCountryData[indexPath.row] as! NSDictionary
        
        
        lblCountryName.text = objBook.valueForKey("country") as? String
        lbliPAddress.text = objBook.valueForKey("ip_address") as? String
        
        
        /*if let url = NSURL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png") {
            if let data = NSData(contentsOfURL: url){
                imgvImage.contentMode = UIViewContentMode.ScaleAspectFit
                imgvImage.image = UIImage(data: data)
            }
        }*/
        
        var imgURL = NSURL(string: "http://www.apple.com/euro/ios/ios8/a/generic/images/og.png")
        
        let request: NSURLRequest = NSURLRequest(URL: imgURL!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
            if error == nil {
                imgvImage.contentMode = UIViewContentMode.ScaleAspectFit
                imgvImage.image = UIImage(data: data!)!
            }
            else {
                print("Error: \(error!.localizedDescription)")
            }
            })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None


        // Configure the cell...

        return cell
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete
        {
            // Delete the row from the data source
            let objPerson:Country = self.arrPersons[indexPath.row] as! Country
            
            managedObjectContext.deleteObject(objPerson)
            do {
                try managedObjectContext.save()
            } catch _ {
            }
            self.retrievePersonData()
            
            //self.tableView.reloadData()
            
        }
        else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detail"
        {
            if let nav = segue.destinationViewController as? UIViewController
            {
                if let vc = nav as? DetailViewController
                {
                    let indexpath = self.tableView.indexPathForSelectedRow
                    
                    let objCountry:Country = self.arrPersons[indexpath!.row] as! Country
                    
                    vc.objCountry = objCountry

                }
                
                
                
            }
        }
    }


}
