//
//  User+CoreDataClass.swift
//  Colour Memory
//
//  Created by Vignesh on 10/05/17.
//  Copyright © 2017 Vigneshuvi. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    @NSManaged public var name: String?
    @NSManaged public var score: Int16
    @NSManaged public var startDate: NSDate?
    @NSManaged public var endDate: NSDate?
    
   
}
