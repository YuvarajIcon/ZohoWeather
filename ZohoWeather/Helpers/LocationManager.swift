//
//  LocationManager.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import CoreLocation

/**
 LocationManager

 A class for managing location services and retrieving the current location and city.
 */
class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation, Error>?
        
    var currentLocation: CLLocation {
        get async throws {
            return try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                locationManager.requestLocation()
            }
        }
    }
    
    var currentCity: String {
        get async throws {
            return try await withCheckedThrowingContinuation { continuation in
                Task {
                    do {
                        let coordinate = try await currentLocation
                        let placemark = try await reverseGeocodeLocation(coordinate)
                        if let city = placemark.locality {
                            continuation.resume(returning: city)
                        } else {
                            continuation.resume(throwing: LocationError.cityNotFound)
                        }
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.checkAuthorization()
    }
    
    private func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            return
        }
    }

    private func reverseGeocodeLocation(_ coordinate: CLLocation) async throws -> CLPlacemark {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(coordinate)
            if let firstPlacemark = placemarks.first {
                return firstPlacemark
            } else {
                throw LocationError.cityNotFound
            }
        } catch {
            throw LocationError.geocodingError(error.localizedDescription)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            continuation?.resume(returning: lastLocation)
            continuation = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}

enum LocationError: Error {
    case locationServicesDisabled
    case locationError(String)
    case geocodingError(String)
    case cityNotFound
}

