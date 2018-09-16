//
//  DeliveryViewModel.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 16/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewModel: NSObject {
    
    // Can't init is singleton
    private override init() { }
    
    // MARK: - Shared Instance
    
    static let shared = ViewModel()
    
    // MARK: - Variables
    
    var deliveryItems: [DeliveryItem] = []
    var deliveryItem: [Delivery] = []
    var imageCache = NSCache<AnyObject, AnyObject>()
    var offSet = 0
    var lastFetchedCount = 0
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    //MARK: - API Call Method
    
    func getDeliveryItems(completion: @escaping () -> Void) {
        
        if !Reachability.isConnectedToNetwork() {
            
            CoreDataService.shared.getDeliveriesFromDB(offSet: offSet, fetchLimit: kLimit) { (completed, deliveriesReturned) in
                lastFetchedCount = deliveriesReturned.count
                
                if offSet == 0 {
                    self.deliveryItem = []
                }
                
                for everyDelivery in deliveriesReturned {
                    let delivery = DeliveryItem(delivery: everyDelivery)
                    self.deliveryItems.append(delivery)
                }
                
                if deliveriesReturned.count == 10 {
                    offSet += kLimit
                }
                
                // Putting completion on main thread
                DispatchQueue.main.async {
                    completion()
                }
            }
            
        } else {
            
            APIClient.shared.fetchDeliveryItemList() { (deliveryItemsReturned) in
                
                /*
                 - Putting this block on main queue because our completion handler is where the data will display and we don't want to block any UI code.
                 */
                
                DispatchQueue.main.async { [weak self] in
                    self?.deliveryItems = deliveryItemsReturned
                    completion()
                }
            }
        }
    }
    
    // MARK: - Data For UITableView
    
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return deliveryItems.count
    }
    
    func deliveryDescription(for indexPath: IndexPath) -> String {
        return deliveryItems[indexPath.row].description
    }
    
    func deliveryAddress(for indexPath: IndexPath) -> String {
        return deliveryItems[indexPath.row].address
    }
    
    func deliveryItemImageUrl(for indexPath: IndexPath, completion: @escaping (UIImage?) -> ()) {
        
        if let image = imageCache.object(forKey: (deliveryItems[indexPath.row].imageUrl as NSString?)!) as? UIImage {
            completion(image)
        
        } else {
            
            if let url = URL(string: deliveryItems[indexPath.row].imageUrl) {
                
                URLSession.shared.dataTask(with: url) { [weak self] (data , response , error ) in
                    
                    if error != nil {
                        return
                    
                    } else {
                        let image = UIImage(data: data!)
                        self?.imageCache.object(forKey: (self?.deliveryItems[indexPath.row].imageUrl as NSString?)!)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            completion(image!)
                        })
                    }
                }.resume()
           
            } else {
                completion(nil)
            }
        }
    }
}
