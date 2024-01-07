//
//  Preference.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation

@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value?
    
    init(key: String, defaultValue: Value? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    public var wrappedValue: Value? {
        get {
            return UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            if let value = newValue {
                UserDefaults.standard.set(value, forKey: key)
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}

enum TemparatureUnit: String, Codable {
    case fahrenheit = "Fahrenheit"
    case celsius = "Celsius"
}

enum PreferenceKeys: String {
    case temperature
}

/**
 Preference

 A singleton class responsible for managing user preferences using UserDefaults.
 */
final class Preference {
    static let shared = Preference()
    private init() {}
    
    var temperatureUnit: TemparatureUnit? {
        get {
            guard let temperatureUnitString else {
                return nil
            }
            return TemparatureUnit(rawValue: temperatureUnitString)
        }
        set (newValue) {
            temperatureUnitString = newValue?.rawValue
        }
    }
    
    @UserDefault(key: PreferenceKeys.temperature.rawValue, defaultValue: TemparatureUnit.celsius.rawValue)
    private var temperatureUnitString: String?
}
