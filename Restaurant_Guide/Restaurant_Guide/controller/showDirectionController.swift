//
//  showDirectionController.swift
//  Restaurant_Guide
//
//  Created by Lei Jing, Jes Muli, Daniel Lee on 2021-04-18.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class showDirectionController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private var currentLocation: CLLocation?
    var locationManager = CLLocationManager()
    var getLat = 0.0
    var getLong = 0.0
    
    //var previousLocation: CLLocation?
        
    let geoCoder = CLGeocoder()
    //var directionsArray: [MKDirections] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView.delegate = self
        mapView.showsScale = true
        //mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        var sourceLocation = locationManager.location?.coordinate // current location
        if sourceLocation == nil {
            sourceLocation = CLLocationCoordinate2D(latitude: 43.779764, longitude: -79.415496) // default location if using simulator
        }
        let destinationLocation = CLLocationCoordinate2D(latitude: getLat, longitude: getLong)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            
        let sourceRegion = MKCoordinateRegion(center: sourceLocation!, span: span)
        mapView.setRegion(sourceRegion, animated: true)
            
        let destinationRegion = MKCoordinateRegion(center: destinationLocation, span: span)
        mapView.setRegion(destinationRegion, animated: true)
            
        let sourcePin = MKPointAnnotation()
        sourcePin.coordinate = sourceLocation!
        mapView.addAnnotation(sourcePin)
            
        let destinationPin = MKPointAnnotation()
        destinationPin.coordinate = destinationLocation
        mapView.addAnnotation(destinationPin)
            

        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: sourcePlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Directions Error: \(error)")
                }
                    return
                }
                let route = response.routes[0]
                self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }

    }
    
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
             let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 4.0
            return renderer
        }
    
    
}
