//
//  ScoreViewController.swift
//  Colour Memory
//
//  Created by Vignesh on 10/05/17.
//  Copyright © 2017 Vigneshuvi. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ScoreViewController: UIViewController,UITableViewDelegate,UITableViewDataSource  {
     var dataSource = [User]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0));
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "User List";
        dataSource = fetchUserProfiles();
        // Do any additional setup after loading the view.
    }

    func fetchUserProfiles() -> Array<User> {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let users = try! CoreDataManager.sharedInstance.managedObjectContext.fetch(fetchRequest)
        if (!users.isEmpty) {
            print(users)
            return users
        }
        else {
            return users
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userObj:User = self.dataSource[indexPath.row];
        let cell:UserCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell;
        cell.scoreLabel.text = "\(userObj.score)"
        cell.rankLabel.text = " \(indexPath.row+1) "
        cell.nameLabel.text = userObj.name
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
