//
//  CompassController.swift
//  CompassExample
//
//  Created by Liu Chuan on 2018/3/10.
//  Copyright © 2018年 LC. All rights reserved.
//

import UIKit
import CoreLocation
import Contacts

/// Compass controller
class CompassController: UIViewController {

    // MARK: - Lazy Loading View
    
    // location information
    /// Location manager
    private lazy var locationManager : CLLocationManager = CLLocationManager()
    private lazy var currLocation: CLLocation = CLLocation()
    
    /// Scale view
    fileprivate lazy var dScaView: DegreeScaleView = {
        let viewF = CGRect(x: 0, y: 0, width: view.frame.size.width - 30, height: view.frame.size.width - 30)
        let scaleV = DegreeScaleView(frame: viewF)
        scaleV.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height / 2)
        scaleV.backgroundColor = .black
        return scaleV
    }()
    
    /// Angle label
    private lazy var angleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: dScaView.frame.maxY, width: view.frame.size.width / 2, height: 100))
        label.font = UIFont.systemFont(ofSize: 60)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    /// Direction label
    private lazy var directionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: view.frame.size.width / 2, y: angleLabel.frame.origin.y, width: view.frame.width / 2, height: 25))
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()

    /// Location Label
    private lazy var positionLabel: UILabel = {
        let viewF = CGRect(x: view.frame.size.width / 2, y: directionLabel.frame.maxY, width: view.frame.size.width / 2, height: directionLabel.Height * 2)
        let label = UILabel(frame: viewF)
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        return label
    }()
    
    /// Latitude and longitude Label
    private lazy var latitudeAndLongitudeLabel: UILabel = {
        let viewF = CGRect(x: 0, y: angleLabel.frame.maxY, width: view.frame.size.width, height: 30)
        let label = UILabel(frame: viewF)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    /// Altitude Label
    private lazy var altitudeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: latitudeAndLongitudeLabel.frame.maxY, width: view.frame.maxX, height: 30))
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: - Destroy
    // deinit() Class deinitialization (destruction method)
    deinit {
        locationManager.stopUpdatingHeading()   // Stop obtaining heading data, save power
        locationManager.delegate = nil
    }
    
    // MARK: - System Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        createLocationManager()
    }
}

// MARK: - Custom Method
extension CompassController {
    
    /// Configuring the UI interface
    private func configUI() {
        view.backgroundColor = .black
        addSub()
    }
    
    /// Add view
    private func addSub() {
        view.addSubview(dScaView)
        view.addSubview(angleLabel)
        view.addSubview(directionLabel)
        view.addSubview(positionLabel)
        view.addSubview(latitudeAndLongitudeLabel)
        view.addSubview(altitudeLabel)
    }
    
    /// Create an initial positioning device
    private func createLocationManager() {
        
        /**
         * Location information
         *
         * longitude：currLocation.coordinate.longitude
         * latitude：currLocation.coordinate.latitude
         * altitude：currLocation.altitude
         * direction：currLocation.course
         * speed：currLocation.speed
         *  ……
         */
        
        locationManager.delegate = self
        
        // The location location manager updates the frequency. The higher the accuracy of the location requirement, the
        // smaller the value of the distanceFilter attribute. It refers to how many meters the device (horizontal or vertical)
        // moves before sending another update to the delegate.
        locationManager.distanceFilter = 0
        
        // Set the accuracy of positioning. The more accurate, the higher the power consumption.
        // kCLLocationAccuracyBestForNavigation: The highest precision, generally used for navigation.
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        /** Send authorization request **/
        // Always Authorized: Allows authorization to obtain user location in the foreground
        //locationManager.requestAlwaysAuthorization()
        // When used: Request authorization
        locationManager.requestWhenInUseAuthorization()
        
        // Allow background positioning update, blue bar flashes after entering the background
        locationManager.allowsBackgroundLocationUpdates = true

        // Determine if the positioning device allows the use of location services and whether to obtain navigation data
        if CLLocationManager.locationServicesEnabled() && CLLocationManager.headingAvailable() {
            locationManager.startUpdatingLocation()     // Start location service
            locationManager.startUpdatingHeading()      // Start getting device orientation
            print("Start of positioning")
        }else {
            print("Cannot obtain heading data")
        }
    }
    
    /// Update the current mobile phone (camera) orientation
    ///
    /// - Parameter newHeading: Oriented
    private func update(_ newHeading: CLHeading) {
        
        /// Oriented
        let theHeading: CLLocationDirection = newHeading.magneticHeading > 0 ? newHeading.magneticHeading : newHeading.trueHeading
        
        /// angle
        let angle = Int(theHeading)
        
        switch angle {
        case 0:
            directionLabel.text = "N"
        case 90:
            directionLabel.text = "E"
        case 180:
            directionLabel.text = "S"
        case 270:
            directionLabel.text = "W"
        default:
            break
        }
        
        if angle > 0 && angle < 90 {
            directionLabel.text = "NE"
        }else if angle > 90 && angle < 180 {
            directionLabel.text = "SE"
        }else if angle > 180 && angle < 270 {
            directionLabel.text = "SW"
        }else if angle > 270 {
            directionLabel.text = "NW"
        }
    }
    
    /// Get the current device orientation (magnetic north direction)
    ///
    /// - Parameters:
    ///   - heading: Oriented
    ///   - orientation: Equipment direction
    /// - Returns: Float
    private func heading(_ heading: Float, fromOrirntation orientation: UIDeviceOrientation) -> Float {
        
        var realHeading: Float = heading
        
        switch orientation {
        case .portrait:
            break
        case .portraitUpsideDown:
            realHeading = heading - 180
        case .landscapeLeft:
            realHeading = heading + 90
        case .landscapeRight:
            realHeading = heading - 90
        default:
            break
        }
        if realHeading > 360 {
            realHeading -= 360
        }else if realHeading < 0.0 {
            realHeading += 366
        }
        return realHeading
    }
}


// MARK: - CLLocationManagerDelegate
extension CompassController: CLLocationManagerDelegate {
    
    // Navigation related methods
    
    // Callback method after successful positioning, as long as the position changes, this method will be called
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        // Get the latest coordinates
        currLocation = locations.last!
        
        /// longitude
        let longitudeStr = String(format: "%3.2f", currLocation.coordinate.longitude)
        
        /// latitude
        let latitudeStr = String(format: "%3.2f", currLocation.coordinate.latitude)
        
        /// altitude
        let altitudeStr = "\(Int(currLocation.altitude))"
        
        
        /***** 1. Processing longitude *****/
        /// String range interception
        let stringRange = longitudeStr.range(of: ".")
        
        /// Integer: Intercept according to a string. Intercept the character before the decimal point
        let wholeNumber = longitudeStr.prefix(upTo: stringRange!.lowerBound)
        
        /// After the decimal point, the character after the decimal point is truncated
        let decimalPointBehind = longitudeStr.suffix(from: stringRange!.upperBound)
        
        /// Integer after splicing degree (°)
        let newWholeNumber = wholeNumber + "°"
        
        /// After the splicing (')
        let newDecimalPointBehind = decimalPointBehind + "'"
        
        /// New stitching east longitude
        let newLongitudeStr = newWholeNumber + newDecimalPointBehind
        
        /***** 2. Processing latitude *****/
        /// String range interception
        let stringRange2 = latitudeStr.range(of: ".")
        
        /// Integer: Intercept according to a string. Intercept the character before the decimal point
        let wholeNumber2 = latitudeStr.prefix(upTo: stringRange2!.lowerBound)
        
        /// After the decimal point, the character after the decimal point is truncated
        let decimalPointBehind2 = latitudeStr.suffix(from: stringRange2!.upperBound)
        
        /// Integer after splicing degree (°)
        let newWholeNumber2 = wholeNumber2 + "°"
        
        /// After the splicing (')
        let newDecimalPointBehind2 = decimalPointBehind2 + "'"
        
        /// New stitching north latitude
        let newlatitudeStr = newWholeNumber2 + newDecimalPointBehind2
        
//        latitudeAndLongitudeLabel.text = "North latitude: \(latitudeStr) East:\(longitudeStr)"
        
        latitudeAndLongitudeLabel.text = "north latitude：\(newlatitudeStr)  East longitude：\(newLongitudeStr)"
        
        altitudeLabel.text = "altitude：\(altitudeStr) M"

        // Anti-geographic coding
        /// Create a CLGeocoder object
        let geocoder = CLGeocoder()
        
        /*** Reverse geocoding request ***/
        
        // According to the given latitude and longitude address reverse parsing, get the string address.
        geocoder.reverseGeocodeLocation(currLocation) { (placemarks, error) in
            
            guard let placeM = placemarks else { return }
            // If the parsing succeeds, execute the following code
            guard placeM.count > 0 else { return }
            /* placemark: Structure containing all location information */
            // Landmark objects containing information such as districts, streets, etc.
            let placemark: CLPlacemark = placeM[0]
            
            /// Store streets, provinces and other information
            let addressDictionary = placemark.postalAddress
            
            /// country
            guard let country = addressDictionary?.country else { return }
            
            /// city
            guard let city = addressDictionary?.city else { return }
            
            /// Sub-location
            guard let subLocality = addressDictionary?.subLocality else { return }
            
            /// street
            guard let street = addressDictionary?.street else { return }
       
            self.positionLabel.text = "\(country)\n\(city) \(subLocality) \(street)"
        }
 
    }

    // Obtain the device geography and geomagnetic orientation data to rotate the geoscale and text labels on the table
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        /*
            trueHeading     : True north direction
            magneticHeading : Magnetic north direction
         */
        /// Get current device
        let device = UIDevice.current
        
        // 1. Determine whether the current magnetometer's angle is valid (if this value is less than 0, it means the
        // angle is invalid), the smaller the more accurate
        if newHeading.headingAccuracy > 0 {
            
            // 2. Get the current device orientation (magnetic north direction) data
            let magneticHeading: Float = heading(Float(newHeading.magneticHeading), fromOrirntation: device.orientation)
            
            // Geographic heading data: trueHeading
            //let trueHeading: Float = heading(Float(newHeading.trueHeading), fromOrirntation: device.orientation)
         
            /// Geomagnetic north direction
            let headi: Float = -1.0 * Float.pi * Float(newHeading.magneticHeading) / 180.0
            // Set the angle label text
            angleLabel.text = "\(Int(magneticHeading))°"

            // 3. Rotation transformation
            dScaView.resetDirection(CGFloat(headi))
            
            // 4. The current mobile phone (camera) is oriented
            update(newHeading)
        }
    }
   
    // Determine whether the device needs to be verified and is subject to interference from external magnetic fields.
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    // Location agent failure callback
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed....\(error)")
    }
    
    /// Called if the authorization status changes
    ///
    /// - Parameters:
    ///   - manager: Location manager
    ///   - status: Current authorization status
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
 
        switch status {
        case .notDetermined:
            print("User has not decided")
        case .restricted:
            print("Restricted")
        case .denied:
            // Determine whether the current device supports positioning and whether the positioning service is enabled.
            if CLLocationManager.locationServicesEnabled() {
                print("Positioning turned on, rejected")
            }else {
                print("Location service is down")
            }
        case .authorizedAlways:
            print("Front, background positioning authorization")
        case .authorizedWhenInUse:
            print("Front-end location authorization")
        }
    }
    
 
}
