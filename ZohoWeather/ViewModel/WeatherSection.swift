//
//  WeatherSection.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation

enum WeatherSectionType: String {
    case fivedayForecast = "5 DAY FORECAST"
    case feelslike = "FEELS LIKE"
    case precipitation = "PRECIPITATION"
    case visibility = "VISIBILITY"
    case humidity = "HUMIDITY"
}

struct WeatherSection: Hashable {
    var type: WeatherSectionType
    var rows: [WeatherRow]
    
    static func generate(with model: WeatherData) -> [WeatherSection] {
        let forecastSection = WeatherSection(
            type: .fivedayForecast,
            rows: WeatherRow.generate(with: model, for: .fivedayForecast)
        )
        let feelsLikeSection = WeatherSection(
            type: .feelslike,
            rows: WeatherRow.generate(with: model, for: .feelslike)
        )
        let humiditySection = WeatherSection(
            type: .humidity,
            rows: WeatherRow.generate(with: model, for: .humidity)
        )
        let precipitationSection = WeatherSection(
            type: .precipitation,
            rows: WeatherRow.generate(with: model, for: .precipitation)
        )
        let visibilitySection = WeatherSection(
            type: .visibility,
            rows: WeatherRow.generate(with: model, for: .visibility)
        )
        
        let sections = [
            forecastSection,
            feelsLikeSection,
            humiditySection,
            precipitationSection,
            visibilitySection
        ]
        return sections
    }
}
