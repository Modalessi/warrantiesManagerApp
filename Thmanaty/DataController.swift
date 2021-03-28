//
//  DataController.swift
//  Thmanat
//
//  Created by Mohammed Alessi on 25/01/1442 AH.
//  Copyright © 1442 Mohammed Alessi. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(model: String) {
        persistentContainer = NSPersistentContainer(name: model)
    }
    
    func load(completion: (()->Void)? = nil) {
        persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
}
