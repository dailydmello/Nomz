//
//  CoreDataHelper.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-25.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//


import CoreData
import UIKit

struct CoreDataHelper {

    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newSwipedFood() -> SwipedFood {
        let swipedFood = NSEntityDescription.insertNewObject(forEntityName: Constants.CoreData.entityName, into: context) as! SwipedFood
        return swipedFood
    }
    
    static func saveSwipedFood(){
        do{
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(_ swipedFood: SwipedFood){
        context.delete(swipedFood)
        saveSwipedFood()
    }
    
    static func retrieveSwipedFood() -> [SwipedFood]{
        do{
            let fetchRequest = NSFetchRequest<SwipedFood>(entityName: Constants.CoreData.entityName)
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch in coredata \(error.localizedDescription)")
            
            return[]
        }
    }
}
