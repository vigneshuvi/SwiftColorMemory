//
//  ViewController.swift
//  Colour Memory
//
//  Created by Vignesh on 10/05/17.
//  Copyright © 2017 Vigneshuvi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  {

    @IBOutlet var collectionView: UICollectionView!
    var dataSource = [CardModel]()
    var selectedCard:Int = -1;
    var selectedCount:Int = 0;
    var score:Int = 0;
    var clickTime : DispatchTime? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.reloadDataSource();
        self.updateScore();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateScore() {
        self.navigationItem.title = "\(score)"
    }
    
    func reloadCollection() {
        self.clickTime = nil;
        self.score = 0;
        self.selectedCard = -1;
        self.selectedCount = 0;
        self.updateScore();
        self.reloadDataSource();
        self.collectionView.reloadData();
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        self.reloadCollection();
    }
    @IBAction func logoClickAction(_ sender: Any) {
        
    }
    @IBAction func highScoreAction(_ sender: Any) {
        DispatchQueue.main.async() {
            [unowned self] in
            self.performSegue(withIdentifier: "home_to_highscore", sender: self)
        }
    }
    // MARK: - Utils Methods
    
    // Help to reload and generate the random string.
    func reloadDataSource() {
        if(self.dataSource.count > 0) {
            self.dataSource.removeAll();
        }
        
        var nums = [1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8]
        var randomNumbers = [Int]()
        while nums.count > 0 {
            // Random key from array
            let arrayKey = Int(arc4random_uniform(UInt32(nums.count)))
            // Get random number
            let randNum = nums[arrayKey]
            randomNumbers.append(randNum);
            // make sure the number isnt repeated
            nums.remove(at: arrayKey)
        }
        
        var index: Int  = 0;
        for i in 0 ..< 4 {
            for j in 0 ..< 4 {
                let obj:CardModel = CardModel();
                obj.position = "\(i)\(j)";
                obj.isSelected = false;
                obj.isDisabled = false;
                obj.cardType = randomNumbers[index] 
                index += 1;
                self.dataSource.append(obj)
            }
        }
    }
    
    // Updated the Card model based on type
    func updateSelectedCard(withCardType type:Int, isDisable:Bool ) {
        if type > 0 {
            let selectedCardArray = self.dataSource.filter { $0.cardType == type }
            for i in 0 ..< selectedCardArray.count {
                let obj1 :CardModel = selectedCardArray[i];
                obj1.isDisabled = isDisable;
                obj1.isSelected = isDisable;
                let Index  = self.dataSource.index(of: obj1)!;
                self.dataSource[Index] = obj1;
                 UIView.setAnimationsEnabled(false);
                self.collectionView.reloadItems(at: [NSIndexPath(row: Index, section: 0) as IndexPath]);
                UIView.setAnimationsEnabled(true);
                
            }
        }
    }
    
    // Find winning status.
    func isWonMath() ->  Bool {
        let c1Array = self.dataSource.filter { $0.isDisabled == true }
        return c1Array.count == self.dataSource.count ? true : false;
    }
    
    func showAlert()  {

        let actionSheetController: UIAlertController = UIAlertController(title: "Congratulation!", message: "Won the match!", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Ok", style: .default) { action -> Void in
            //Just dismiss the action sheet
            let nameField = actionSheetController.textFields![0] as UITextField
            if (!(nameField.text!.isEmpty) && (nameField.text!.characters.count) > 0) {
                
                let userObj : User = CoreDataManager.sharedInstance.createEntityWithName("User") as! User;
                userObj.name = nameField.text;
                userObj.score = Int16(self.score);
                userObj.endDate = NSDate();
                CoreDataManager.sharedInstance.saveContext();
                self.reloadCollection();
            }
            else{
                self.present(actionSheetController, animated: true, completion: nil)
            }
        }
        //Add user name text field
        actionSheetController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Name"
            textField.textColor = UIColor.brown
        }
        
        actionSheetController.addAction(okAction)
        self.present(actionSheetController, animated: true, completion: nil)
    }


    // MARK: - UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell:CardCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath as IndexPath) as! CardCell
        let obj: CardModel = self.dataSource[indexPath.row]
        if obj.isDisabled  {
            cell.setImageName("\(0)");
        } else {
            if(obj.isSelected) {
                cell.setImageName("\(obj.cardType)");
            } else {
                cell.setImageName("Bg");
            }
        }
        
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if (clickTime != nil) {
            if  self.selectedCount > 2{
                return;
            } else if self.selectedCount == 2 {
                if DispatchTime.now() < clickTime!+1 {
                    return;
                }
            }
            
        }
        
        let obj: CardModel = self.dataSource[indexPath.row]
        if(!obj.isSelected && !obj.isDisabled) {
            obj.isSelected = true;
            self.dataSource[indexPath.row] = obj
            clickTime = DispatchTime.now();
            self.selectedCount += 1;
            let when = clickTime! + 1 // change 1 to desired number of seconds
            UIView.setAnimationsEnabled(false);
            self.collectionView.reloadItems(at: [indexPath]);
            UIView.setAnimationsEnabled(true);
            

            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                
                if self.selectedCard == -1 {
                    self.selectedCard = obj.cardType;
                } else {
                    if self.selectedCard == obj.cardType {
                        self.score += 2;
                        self.updateSelectedCard(withCardType: obj.cardType, isDisable:true);
                    } else {
                        self.updateSelectedCard(withCardType: self.selectedCard, isDisable:false);
                        self.updateSelectedCard(withCardType: obj.cardType, isDisable:false);
                        self.score -= 1;
                    }
                    self.selectedCard = -1;
                    self.selectedCount = 0;
                }
                self.updateScore();
                if self.isWonMath() {
                    self.showAlert()
                }
            })
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }


}

extension ViewController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = (collectionView.frame.size.width-30)/4;
        return CGSize(width: width, height: width+10);
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0,  0, 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


