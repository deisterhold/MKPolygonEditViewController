//
//  ViewController.swift
//  MKPolygonEditViewController
//
//  Created by Daniel Eisterhold on 4/2/16.
//  Copyright © 2016 Daniel Eisterhold. All rights reserved.
//

import UIKit
import MapKit

class MKPolygonEditViewController: UIViewController, MKMapViewDelegate {

    // Map View
    @IBOutlet var mapView:MKMapView!
    
    // Array for holding coordinates
    var coordinates = [CLLocationCoordinate2D]()
    // Polygon to draw on map
    var polygon = MKPolygon()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Add an edit button to the navigation bar
        navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // MARK: Customize the drawing of the map overlay
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        // Create polygon renderer
        let renderer = MKPolygonRenderer(overlay: overlay)
        
        // Set the line color
        renderer.strokeColor = UIColor.orangeColor()

        // Set the line width
        renderer.lineWidth = 5.0
        
        // Return the customized renderer
        return renderer
    }
    
    // MARK: - Get notified when the view begins/ends editing
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            // Disable the map from moving
            mapView.userInteractionEnabled = false
        }
        else {
            // Enable the map to move
            mapView.userInteractionEnabled = true
        }
    }
    
    // MARK: - Handle Touches
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // If editing
        if editing {
            // Empty array
            coordinates.removeAll()

            // Convert touches to map coordinates
            for touch in touches {
                let coordinate = mapView.convertPoint(touch.locationInView(mapView), toCoordinateFromView: mapView)
                coordinates.append(coordinate)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // If editing
        if editing {
            // Convert touches to map coordinates
            for touch in touches {
                // Use this method to convert a CGPoint to CLLocationCoordinate2D
                let coordinate = mapView.convertPoint(touch.locationInView(mapView), toCoordinateFromView: mapView)
                // Add the coordinate to the array
                coordinates.append(coordinate)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // If editing
        if editing {
            // Convert touches to map coordinates
            for touch in touches {
                let coordinate = mapView.convertPoint(touch.locationInView(mapView), toCoordinateFromView: mapView)
                coordinates.append(coordinate)
            }
            
            // Remove existing polygon
            mapView.removeOverlay(polygon)
        
            // Create new polygon
            polygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
            
            // Add polygon to map
            mapView.addOverlay(polygon)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        // If editing
        if editing {
            // Do nothing
        }
    }
}

