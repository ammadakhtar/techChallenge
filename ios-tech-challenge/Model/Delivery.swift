//
//  Delivery.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 16/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import Foundation

struct DeliveryItem: Equatable {
    
    var id = 0
    var description = ""
    var imageUrl = ""
    var latitude = 0.0
    var longitude = 0.0
    var address = ""
    
    /*
     - This init method is to populate our model DeliveryItem from JSON incase of online view.
     - Personally I use Codable protocol but the api provided has a random func in it and is repeating some of the items again and again. I am not being sure if any snakeCase may occur in the JSON returned therefore i am using a dictionary to parse json.
     */
    
    init(deliveryDict: Dictionary <String, AnyObject>) {
        
        if let id = deliveryDict["id"] as? Int {
            self.id = id
        }
        
        if let description = deliveryDict["description"] as? String {
            self.description = description
        }
        
        if let imageUrl = deliveryDict["imageUrl"] as? String {
            self.imageUrl = imageUrl
        }
        
        if let location = deliveryDict["location"] as? Dictionary<String,AnyObject> {
            
            if let latitude = location["lat"] as? Double {
                self.latitude = latitude
            }
            
            if let longitude = location["long"] as? Double {
                self.longitude = longitude
            }
            
            if let address = location["address"] as? String {
                self.address = address
            }
        }
    }
    
    /*
     - This init method is to populate our model DeliveryItem from CoreData incase of offline view.
     */
    
    init(delivery: Delivery) {
        self.id = Int(delivery.id)
        self.description = delivery.deliveryDesc!
        self.imageUrl = delivery.imageUrl!
        self.latitude = delivery.latitude
        self.longitude = delivery.longitude
        self.address = delivery.address!
    }
    
    // MARK: - Init Method For Unit Testing
    
    init(id: Int, description: String, imageUrl: String, latitude: Double, longitude: Double, address: String) {
        self.id = id
        self.description = description
        self.imageUrl = imageUrl
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    // MARK: Equatable Protocol
    
    static func == (lhs: DeliveryItem, rhs: DeliveryItem) -> Bool {
        
        if lhs.id == rhs.id {
            return true
        }
        return false
    }
}
