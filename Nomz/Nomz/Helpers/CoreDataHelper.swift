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
    //computed class variable reference to app delegate's managed object context to create, edit, and delete NSManaged Object
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
    
    static func newFoodOffer() -> FoodOffer {
        let foodOffer = NSEntityDescription.insertNewObject(forEntityName: "FoodOffer", into: context) as! FoodOffer
        return foodOffer
    }
    
    static func saveFoodOffer(){
        do{
            try context.save()
        } catch let error {
            print("Could not save \(error.localizedDescription)")
        }
    }
    
    static func delete(foodOffer: FoodOffer){
        context.delete(foodOffer)
        saveFoodOffer()
    }
    
    static func retrieveFoodOffer() -> [FoodOffer]{
        do{
            let fetchRequest = NSFetchRequest<FoodOffer>(entityName: "FoodOffer")
            let results = try context.fetch(fetchRequest)
            
            return results
        } catch let error {
            print("Could not fetch \(error.localizedDescription)")
            
            return[]
        }
    }
}
