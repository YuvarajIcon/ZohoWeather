//
//  WeatherEndPoint.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import Alamofire

enum WeatherEndPoint: Endpoint {
    case current(city: String)
    case forecast(city: String, upto: Int)
    
    var path: String {
        switch self {
        case .current(let city):
            return "/current.json?q=\(city)"
        case .forecast(let city, let days):
            return "/forecast.json?q=\(city)&days=\(days)&hour=12"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .current, .forecast:
            return .get
        }
    }
}
