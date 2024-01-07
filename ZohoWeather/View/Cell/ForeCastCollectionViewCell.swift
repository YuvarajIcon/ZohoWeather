//
//  ForeCastCollectionViewCell.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import UIKit

class ForeCastCollectionViewCell: UICollectionViewCell {
    static let reuseID = "forecastCell"
    private lazy var weatherView: MiniWeatherView = {
        let view = MiniWeatherView(temperature: "", date: Date(), iconSource: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupView() {
        contentView.addSubview(weatherView)
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            weatherView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            weatherView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(with row: WeatherRow) {
        weatherView.reconfigure(temperature: row.value, date: row.date, iconSource: row.iconSource)
    }
}
