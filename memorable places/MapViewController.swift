//
//  MapViewController.swift
//  memorable places
//
//  Created by Animesh Manglik on 12/16/16.
//  Copyright © 2016 Animesh Manglik. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let uilpgr: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(gestureRecognizer:)))
        
        uilpgr.minimumPressDuration = 2
        
        mapView.addGestureRecognizer(uilpgr)
        
        if (activePlace != -1) {
            
            // Get Place detail to display on map
            
            if places.count > 0 {
            
                if let name = places[activePlace]["name"] {
                    if let lat = places[activePlace]["lat"] {
                        if let long = places[activePlace]["long"] {
                            if let latitude = Double(lat) {
                                if let longitude = Double(long) {
                                    
                                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                                    
                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                    
                                    let region = MKCoordinateRegion(center: coordinate, span: span)
                                    
                                    self.mapView.setRegion(region, animated: true)
                                    
                                    let annotation = MKPointAnnotation()
                                    
                                    annotation.title = name
                                    
                                    annotation.coordinate = coordinate
                                    
                                    self.mapView.addAnnotation(annotation)
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func longpress(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            
            let newCordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
           
            let location = CLLocation(latitude: newCordinate.latitude, longitude: newCordinate.longitude)
            
            var title = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if(error != nil) {
                    print("Error \(error)")
                } else {
                    if let placemark = placemarks?[0] {

                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                    }

                    if (title == "") {
                        title = "Added \(NSDate())"
                    }
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = newCordinate
                    
                    annotation.title = title
                    
                    self.mapView.addAnnotation(annotation)
                    
                    places.append(["name":title, "lat": String(newCordinate.latitude), "long": String(newCordinate.longitude)])
                    
                    UserDefaults.standard.set(places, forKey:"places")
                }
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
