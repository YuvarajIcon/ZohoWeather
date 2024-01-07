//
//  WeatherRow.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation
import Kingfisher

struct WeatherRow: Hashable {
    var date: Date
    var description: String?
    var iconSource: Source?
    var value: String
    
    static func generate(with model: WeatherData, for type: WeatherSectionType) -> [WeatherRow] {
        switch type {
        case .fivedayForecast:
            return generateForeCastRows(with: model)
        case .feelslike:
            return generateFeelsLikeRows(with: model)
        case .precipitation:
            return generatePrecipitationRows(with: model)
        case .visibility:
            return generateVisibilityRows(with: model)
        case .humidity:
            return generateHumidityRows(with: model)
        }
    }
    
    static private func generateForeCastRows(with model: WeatherData) -> [WeatherRow] {
        guard let forecast = model.forecast else {
            return []
        }
        var rows: [WeatherRow] = []
        for forecastDay in forecast.forecastDay {
            rows.append(WeatherRow(
                date: forecastDay.date.toDate(withFormat: DateUtils.yyyyMMdd) ?? Date(),
                description: forecastDay.day.conditionText,
                iconSource: forecastDay.day.iconSource,
                value: "\(forecastDay.day.temperature)°")
            )
        }
        return rows
    }
    
    static private func generateFeelsLikeRows(with model: WeatherData) -> [WeatherRow] {
        return [WeatherRow(date: Date(), value: "\(model.current.feelsLike)°")]
    }
    
    static private func generatePrecipitationRows(with model: WeatherData) -> [WeatherRow] {
        return [WeatherRow(date: Date(), value: "\(model.current.precipMm) mm")]
    }
    
    static private func generateVisibilityRows(with model: WeatherData) -> [WeatherRow] {
        return [WeatherRow(date: Date(), value: "\(model.current.visibilityKm) Km")]
    }
    
    static private func generateHumidityRows(with model: WeatherData) -> [WeatherRow] {
        return [WeatherRow(date: Date(), value: "\(model.current.humidity)%")]
    }
}

