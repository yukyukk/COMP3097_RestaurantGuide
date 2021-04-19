//
//  showMapsController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-04-18.
//

import Foundation
import UIKit
import CoreLocation
import MapKit


class showMapsController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager:CLLocationManager!
    var getAddress = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let location = getAddress
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let mark = MKPlacemark(placemark: placemark)

                if var region = self?.map.region {
                    region.center = location.coordinate
                    region.span.longitudeDelta /= 10.0
                    region.span.latitudeDelta /= 10.0
                    self?.map.setRegion(region, animated: true)
                    self?.map.addAnnotation(mark)
                }
            }
        }
    }
}
