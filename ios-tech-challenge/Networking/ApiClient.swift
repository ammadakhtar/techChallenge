//
//  ApiClient.swift
//  ios-tech-challenge
//
//  Created by Ammad Akhtar on 16/09/2018.
//  Copyright © 2018 Ammad Akhtar. All rights reserved.
//

import UIKit

class APIClient: NSObject {
    
    // Can't init is singleton
    private override init() { }
    
    // MARK: Shared Instance
    
    static let shared = APIClient()
    
    // MARK: - Variables
    
    var deliveryItemsArray =  [DeliveryItem]()
    
    // MARK: - Private Methods
    
    /* The completion handler will be executed after properties data is fetched
     our completion handler will include an optional array of NSDictionaries parsed from our retrieved JSON object */
    
    func fetchDeliveryItemList(completion: @escaping ([DeliveryItem]) -> Void) {
        
        // unwrap our API endpoint
        let endPointUrl = "\(kBaseUrl)?offset=\(ViewModel.shared.offSet)&&limit=\(kLimit)"
        guard let url = URL(string: endPointUrl) else { return }
        
        // create a session and dataTask on that session to get data/response/error
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { [weak self] (data, response, error) in
            
            // unwrap our returned data
            guard let unwrappedData = data else {
                completion([])
                return
            }
            
            do {
                
                if let deliveriesListJSON = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments) as? [Any] {
                    ViewModel.shared.lastFetchedCount = deliveriesListJSON.count
                    
                    if ViewModel.shared.offSet == 0 {
                        self?.deliveryItemsArray = []
                     }
                    
                    for delivery in deliveriesListJSON {
                            let deliveryItem = DeliveryItem(deliveryDict: delivery as! Dictionary<String, AnyObject>)
                            self?.deliveryItemsArray.append(deliveryItem)
                        }
                    
                    DispatchQueue.main.async {
                    CoreDataService.shared.saveDeliveryItemsToDB(deliveries: (self?.deliveryItemsArray)!, completion: { (completed) in

                        if completed {
                        //    print("Success: Saved in coredata successfully")

                        } else {
                          //  print("Error: Failure saving in coredata")
                        }
                    })
                }
                    
                    if deliveriesListJSON.count == 10 {
                        ViewModel.shared.offSet += kLimit
                    }
                    
                    completion((self?.deliveryItemsArray)!)
                }
                
            } catch {
                completion([])
                print("Error getting API data: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}

