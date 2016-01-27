//
//  LocationManager.swift
//  Camera
//
//  Created by Griffin Hammer on 1/25/16.
//  Copyright © 2016 Griffin Hammer. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager : NSObject {
    
    private var manager : CLLocationManager = CLLocationManager()
    
    override init(){
        super.init()
        
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.distanceFilter = 500
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    func getCurrentLocation() -> (lat: String, long: String)? {
        guard let loc = manager.location else{
            return nil
        }
        
        return (lat: "\(loc.coordinate.latitude)", long:"\(loc.coordinate.longitude)")
    }
}