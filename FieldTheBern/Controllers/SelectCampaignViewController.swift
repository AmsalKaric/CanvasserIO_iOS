//
//  SelectCampaignViewController.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 7/3/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import UIKit

class SelectCampaignViewController: UITableViewController {
    
    var canvasser = Canvasser.sharedCanvasser
    var campaigns: [Campaign] = []
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch the campaigns and display them now.
        loadCampaigns()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Display campaign count: campaigns.count
        return self.campaigns.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
        
        // Display title: campaigns[indexPath.row].title
        let titleTextLabel = campaigns[indexPath.row].campaign_title
        // Display description: campaigns[indexPath.row].description
        let descriptionTextLabel = campaigns[indexPath.row].campaign_description
        
        cell.textLabel?.text = titleTextLabel
        cell.detailTextLabel?.text = descriptionTextLabel
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            willDisplayCell cell: UITableViewCell,
                                            forRowAtIndexPath indexPath: NSIndexPath) {
        let selected = campaigns[indexPath.row].campaign_id
        if selected == canvasser.selectedCampaignId {
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        
        //New selected campaignId: campaigns[row].Id
        let selectedId = campaigns[row].campaign_id
        let selectedTitle = campaigns[row].campaign_title
        self.canvasser.selectedCampaignId = selectedId
        self.canvasser.selectedCampaignTitle = selectedTitle
        
        self.tableView.reloadData()
        //tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    func loadCampaigns() {
        CampaignService().activeCampaigns { (campaigns, success, error) -> Void in
            if success {
                if let campaigns = campaigns {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.campaigns = campaigns
                        self.tableView.reloadData()
                    })
                }
            } else {
                if let error = error {
                    print("Error!!!!!!!! \(error)")
                }
            }
            
        }
    }
    
    @IBAction func pressCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}