//
//  User+CoreDataProperties.swift
//  Colour Memory
//
//  Created by Vignesh on 10/05/17.
//  Copyright © 2017 Vigneshuvi. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        let fetchRequest =  NSFetchRequest<User>(entityName: "User")
        let sectionSortDescriptor = NSSortDescriptor(key: "score", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest;
    }
    
   
}
