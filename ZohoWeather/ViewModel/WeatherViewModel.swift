//
//  WeatherViewModel.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import Alamofire
import Kingfisher

protocol CurrentWeatherUpdateReceiver: AnyObject {
    func didLoad(with currentWeather: Weather, forCity city: String)
    func didFail(with error: AFError, response: ErrorResponse?)
}

/**
 WeatherViewModel

 A view model responsible for managing weather data and interactions with the API.
 */
final class WeatherViewModel {
    var city: String = ""
    let forecastCount: Int
    var sections: [WeatherSection] = []
    weak var delegate: CurrentWeatherUpdateReceiver?
    
    init(forecastCount: Int) {
        self.forecastCount = forecastCount
    }
    
/**
     Fetches weather data for the specified city and number of forecast days.

     - Parameters:
       - city: The city for which weather data is to be fetched.
       - days: The number of forecast days to consider.
     */
    func getWeather(for city: String, upto days: Int) {
        self.city = city
        APIService.shared.request(endPoint: WeatherEndPoint.forecast(city: city, upto: days), model: WeatherData.self, errorModel: ErrorResponse.self, success: { response in
            self.sections = WeatherSection.generate(with: response)
            self.delegate?.didLoad(with: response.current, forCity: city)
        }, failure: { error, errorResponse in
            self.delegate?.didFail(with: error, response: errorResponse)
        })
    }
    
    /// Refreshes weather data for the current city and forecast count.
    func refresh() {
        self.getWeather(for: self.city, upto: self.forecastCount)
    }
}
