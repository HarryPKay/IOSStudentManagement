//
//  MapViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 27/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

// Shows the location of a student's address on the map when address is set externally.
class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBAction func touchBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // Set from StudentViewController for looking up a student's address.
    var address: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // We don't want to show disabled button if we have not navigated
        // here from the StudentViewController
        if address == nil {
            backButton.isEnabled = false
        }
        showStudentAddressOnMap()
    }
        
    func showStudentAddressOnMap() {
        
        if address == nil {
            return
        }
    
        // Convert the address into the coordinates (lat/long)
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("Locaiton cannot be found")
                    return
            }
            
            // Go to the coordinates.
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.map.setRegion(region, animated: true)
            
            // Set the pin and put it down on the map.
            let annotation = MKPointAnnotation()
            annotation.title = "Student's Address: " + self.address!
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.map.addAnnotation(annotation)
        }
    }
}
