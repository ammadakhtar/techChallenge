//
//  CoreDataService.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 16/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataService: NSObject {
    
    // Can't init is singleton
    private override init() { }
    
    // MARK: - Shared Instance
    
    static let shared = CoreDataService()
    
    // MARK: - Variables
    
    var deliveryArray: [Delivery] = []
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    // MARK: - CoreData Functions
    
    func saveDeliveryItemsToDB(deliveries: [DeliveryItem], completion: (_ finished: Bool) -> ()) {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        for delivery in deliveries {
        let deliveryEntity = Delivery(context: managedContext)
            deliveryEntity.id = Int32(delivery.id)
            deliveryEntity.deliveryDesc = delivery.description
            deliveryEntity.address = delivery.address
            deliveryEntity.imageUrl = delivery.imageUrl
            deliveryEntity.latitude = delivery.latitude
            deliveryEntity.longitude = delivery.longitude
            
            do {
                try managedContext.save()
                completion(true)
                
            } catch {
                completion(false)
            }
        }
    }
    
    func getDeliveriesFromDB(offSet: Int, fetchLimit: Int, completion: (_ finished: Bool, _ deliveriesReturned: [Delivery]) -> ()) {
       
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Delivery>(entityName: "Delivery")
        fetchRequest.fetchOffset = offSet
        fetchRequest.fetchLimit = fetchLimit
        
        do {
            deliveryArray = try managedContext.fetch(fetchRequest)
            
            if deliveryArray.count > 0 {
                completion(true, deliveryArray)
            
            } else {
                completion(false, [])
            }
        } catch {
            completion(false, [])
        }
    }
}
