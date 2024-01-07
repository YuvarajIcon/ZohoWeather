//
//  LargeWeatherView.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import UIKit
import Kingfisher

struct MockWeather: Weather {
    var feelsLike: Double
    var conditionText: String = ""
    var iconSource: Source?
    var temperature: Double { 0 }
}

class LargeWeatherView: UIView {
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 0
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 68)
        label.textColor = .white
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private lazy var conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var temperature: String
    private var conditionDescription: String
    private var iconSource: Source?
    private let imageWidth: CGFloat = 120
    private let imageHeight: CGFloat = 120
    
    init(temperature: String, conditionDescription: String, iconSource: Source?) {
        self.temperature = temperature
        self.conditionDescription = conditionDescription
        self.iconSource = iconSource
        super.init(frame: .zero)
        self.setupView()
        self.configure()
    }

    @available(*, unavailable, message: "Use `init(temperature: , conditionDescription: )` instead")
    convenience init() {
        self.init(temperature: "", conditionDescription: "", iconSource: nil)
    }
    
    @available(*, unavailable, message: "Use `init(temperature: , conditionDescription: )` instead")
    override convenience init(frame: CGRect) {
        self.init(temperature: "", conditionDescription: "", iconSource: nil)
    }
    
    @available(*, unavailable, message: "Use `init(temperature: , conditionDescription: )` instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(conditionImageView)
        containerStackView.addArrangedSubview(temperatureLabel)
        containerStackView.addArrangedSubview(conditionLabel)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            conditionImageView.heightAnchor.constraint(equalToConstant: imageWidth),
            conditionImageView.widthAnchor.constraint(equalToConstant: imageHeight)
        ])
    }
    
    private func configure() {
        conditionLabel.text = self.conditionDescription
        temperatureLabel.text = "\(self.temperature)"
        conditionImageView.kf.setImage(with: self.iconSource)
    }
    
    func reconfigure(temperature: String, conditionDescription: String, iconSource: Source?) {
        self.temperature = temperature
        self.conditionDescription = conditionDescription
        self.iconSource = iconSource
        self.configure()
    }
}
