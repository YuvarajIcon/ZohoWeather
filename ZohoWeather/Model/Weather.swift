//
//  Weather.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import Kingfisher

protocol Weather {
    var feelsLike: Double { get }
    var temperature: Double { get }
    var conditionText: String { get }
    var iconSource: Source? { get }
}

struct WeatherIconResource: Resource {
    var cacheKey: String
    var downloadURL: URL
}

struct ErrorResponse: Codable {
    struct ErrorDetail: Codable {
        let code: Int
        let message: String
    }

    let error: ErrorDetail
}

struct WeatherData: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast?

    private enum CodingKeys: String, CodingKey {
        case location, current, forecast
    }
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let latitude: Double
    let longitude: Double
    let timezoneId: String
    let localtimeEpoch: Int
    let localtime: String

    private enum CodingKeys: String, CodingKey {
        case name, region, country, 
             latitude = "lat",
             longitude = "lon",
             timezoneId = "tz_id",
             localtimeEpoch = "localtime_epoch",
             localtime
    }
}

struct Current: Weather, Codable {
    var temperature: Double {
        switch Preference.shared.temperatureUnit {
        case .fahrenheit:
            return tempFahrenheit
        default:
            return tempCelsius
        }
    }
    
    var feelsLike: Double {
        switch Preference.shared.temperatureUnit {
        case .fahrenheit:
            return feelsLikeFahrenheit
        default:
            return feelsLikeCelsius
        }
    }
    
    var conditionText: String {
        return condition.text
    }
    
    var iconSource: Source? {
        guard let url = URL(string: condition.icon.replacingOccurrences(of: "//", with: "https://")) else {
            return nil
        }
        let resource = WeatherIconResource(cacheKey: condition.icon, downloadURL: url)
        let source = Source.network(resource)
        return source
    }
    
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempCelsius: Double
    let tempFahrenheit: Double
    let isDay: Int
    let condition: Condition
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDirection: String
    let pressureMb: Double
    let pressureInches: Double
    let precipMm: Double
    let precipInches: Double
    let humidity: Int
    let cloud: Int
    let feelsLikeCelsius: Double
    let feelsLikeFahrenheit: Double
    let visibilityKm: Double
    let visibilityMiles: Double
    let uvIndex: Double
    let gustMph: Double
    let gustKph: Double

    private enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch", 
             lastUpdated = "last_updated",
             tempCelsius = "temp_c",
             tempFahrenheit = "temp_f",
             isDay = "is_day", 
             condition,
             windMph = "wind_mph", 
             windKph = "wind_kph",
             windDegree = "wind_degree",
             windDirection = "wind_dir",
             pressureMb = "pressure_mb",
             pressureInches = "pressure_in",
             precipMm = "precip_mm",
             precipInches = "precip_in",
             humidity, cloud,
             feelsLikeCelsius = "feelslike_c",
             feelsLikeFahrenheit = "feelslike_f",
             visibilityKm = "vis_km",
             visibilityMiles = "vis_miles",
             uvIndex = "uv",
             gustMph = "gust_mph",
             gustKph = "gust_kph"
    }
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int

    private enum CodingKeys: String, CodingKey {
        case text, icon, code
    }
}

struct Forecast: Codable {
    let forecastDay: [ForecastDay]

    private enum CodingKeys: String, CodingKey {
        case forecastDay = "forecastday"
    }
}

struct ForecastDay: Codable {
    let date: String
    let dateEpoch: Int
    let day: Day
    let astro: Astro
    let hour: [Hour]

    private enum CodingKeys: String, CodingKey {
        case date, dateEpoch = "date_epoch", day, astro, hour
    }
}

struct Day: Weather, Codable {
    var feelsLike: Double {
        return temperature
    }
    
    var temperature: Double {
        switch Preference.shared.temperatureUnit {
        case .fahrenheit:
            return avgTempFahrenheit
        default:
            return avgTempCelsius
        }
    }
    
    var conditionText: String {
        return condition.text
    }
    
    var iconSource: Source? {
        guard let url = URL(string: condition.icon.replacingOccurrences(of: "//", with: "https://")) else {
            return nil
        }
        let resource = WeatherIconResource(cacheKey: condition.icon, downloadURL: url)
        let source = Source.network(resource)
        return source
    }
    
    let maxTempCelsius: Double
    let maxTempFahrenheit: Double
    let minTempCelsius: Double
    let minTempFahrenheit: Double
    let avgTempCelsius: Double
    let avgTempFahrenheit: Double
    let maxWindMph: Double
    let maxWindKph: Double
    let totalPrecipMm: Double
    let totalPrecipInches: Double
    let totalSnowCm: Double
    let avgVisibilityKm: Double
    let avgVisibilityMiles: Double
    let avgHumidity: Int
    let willItRain: Int
    let chanceOfRain: Int
    let willItSnow: Int
    let chanceOfSnow: Int
    let condition: Condition
    let uvIndex: Double

    private enum CodingKeys: String, CodingKey {
        case maxTempCelsius = "maxtemp_c", 
             maxTempFahrenheit = "maxtemp_f",
             minTempCelsius = "mintemp_c",
             minTempFahrenheit = "mintemp_f",
             avgTempCelsius = "avgtemp_c",
             avgTempFahrenheit = "avgtemp_f",
             maxWindMph = "maxwind_mph",
             maxWindKph = "maxwind_kph",
             totalPrecipMm = "totalprecip_mm",
             totalPrecipInches = "totalprecip_in",
             totalSnowCm = "totalsnow_cm",
             avgVisibilityKm = "avgvis_km",
             avgVisibilityMiles = "avgvis_miles",
             avgHumidity = "avghumidity",
             willItRain = "daily_will_it_rain",
             chanceOfRain = "daily_chance_of_rain",
             willItSnow = "daily_will_it_snow",
             chanceOfSnow = "daily_chance_of_snow", condition,
             uvIndex = "uv"
    }
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moonPhase: String
    let moonIllumination: Int
    let isMoonUp: Int
    let isSunUp: Int

    private enum CodingKeys: String, CodingKey {
        case sunrise, sunset, moonrise, moonset, moonPhase = "moon_phase", moonIllumination = "moon_illumination", isMoonUp = "is_moon_up", isSunUp = "is_sun_up"
    }
}

struct Hour: Codable {
    let timeEpoch: Int
    let time: String
    let tempCelsius: Double
    let tempFahrenheit: Double
    let isDay: Int
    let condition: Condition
    let windMph: Double
    let windKph: Double
    let windDegree: Int
    let windDirection: String
    let pressureMb: Double
    let pressureInches: Double
    let precipMm: Double
    let precipInches: Double
    let snowCm: Double
    let humidity: Int
    let cloud: Int
    let feelsLikeCelsius: Double
    let feelsLikeFahrenheit: Double
    let windChillCelsius: Double
    let windChillFahrenheit: Double
    let heatIndexCelsius: Double
    let heatIndexFahrenheit: Double
    let dewpointCelsius: Double
    let dewpointFahrenheit: Double
    let willItRain: Int
    let chanceOfRain: Int
    let willItSnow: Int
    let chanceOfSnow: Int
    let visibilityKm: Double
    let visibilityMiles: Double
    let gustMph: Double
    let gustKph: Double
    let uvIndex: Double

    private enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch", time, tempCelsius = "temp_c", tempFahrenheit = "temp_f", isDay = "is_day", condition, windMph = "wind_mph", windKph = "wind_kph", windDegree = "wind_degree", windDirection = "wind_dir", pressureMb = "pressure_mb", pressureInches = "pressure_in", precipMm = "precip_mm", precipInches = "precip_in", snowCm = "snow_cm", humidity, cloud, feelsLikeCelsius = "feelslike_c", feelsLikeFahrenheit = "feelslike_f", windChillCelsius = "windchill_c", windChillFahrenheit = "windchill_f", heatIndexCelsius = "heatindex_c", heatIndexFahrenheit = "heatindex_f", dewpointCelsius = "dewpoint_c", dewpointFahrenheit = "dewpoint_f", willItRain = "will_it_rain", chanceOfRain = "chance_of_rain", willItSnow = "will_it_snow", chanceOfSnow = "chance_of_snow", visibilityKm = "vis_km", visibilityMiles = "vis_miles", gustMph = "gust_mph", gustKph = "gust_kph", uvIndex = "uv"
    }
}
