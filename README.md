# Zoho Weather App

## Overview

This project is a weather app developed as part of an assignment for Zoho. The app provides users with current weather information and a 5-day forecast for a given city.

## Features

- **Current Weather:** Get real-time weather information for a specified city, including temperature, weather conditions, and an icon representation.

- **5-Day Forecast:** View a forecast for the next 5 days, including details like temperature, weather conditions, and a summary.

- **Location-based Weather:** The app utilizes the device's location to fetch the weather information for the current city.

- **Settings:** Users can customize their experience by adjusting settings such as the temperature unit (Celsius or Fahrenheit).

## Technologies Used

- **Swift:** The app is developed using the Swift programming language.

- **Alamofire:** Alamofire is used for network requests to fetch weather data from a remote API.

- **Core Location:** Core Location framework is employed to access the device's location.

- **Kingfisher:** Kingfisher is used for efficient image loading and caching for weather icons.

- **UIKit:** UIKit is the primary framework for building the user interface.

## Getting Started

To run the project locally, follow these steps:

1. **Clone the repository:**

   ```bash
   git clone https://github.com/YuvarajIcon/ZohoWeather.git

2. **Open the Xcode project::**

   ```bash
   open ZohoWeather.xcodeproj

## API Key Configuration

The Zoho Weather App uses an API key from [WeatherAPI.com](https://www.weatherapi.com/) to fetch weather information. To set up your own API key, follow these steps:

1. Sign up for a free account on [WeatherAPI.com](https://www.weatherapi.com/) to obtain your API key.

2. Open the Xcode project:

    ```bash
    open ZohoWeather.xcodeproj
    ```

3. In the Xcode project navigator, locate the `ZohoWeather` folder and find the files named `debug.xcconfig` and `release.xcconfig` under the `Config` group.

4. Open both `debug.xcconfig` and `release.xcconfig` files in a text editor of your choice.

5. Locate the line containing `API_KEY = INSERT_YOUR_API_KEY` and replace `INSERT_KEY_HERE` with your actual API key.

    ```plaintext
    API_KEY = YOUR_ACTUAL_API_KEY
    ```

6. Save the changes.

**Note:** Ensure that you replace the API key in both `debug.xcconfig` and `release.xcconfig` files if you plan to test the app in both debug and release modes.

By following these steps, you'll have configured your own API key for the Zoho Weather App.

Build and run the app in the Xcode simulator or on a physical device.
Explore the weather information for different cities, customize settings, and enjoy accurate weather updates!
