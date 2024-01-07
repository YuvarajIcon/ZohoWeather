//
//  MiniWeatherView.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import UIKit
import Kingfisher

class MiniWeatherView: UIView {
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private lazy var conditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var iconSource: Source?
    private var temperature: String
    private var date: Date
    
    init(temperature: String, date: Date, iconSource: Source?) {
        self.temperature = temperature
        self.date = date
        self.iconSource = iconSource
        super.init(frame: .zero)
        self.setupView()
        self.configure()
    }
    
    @available(*, unavailable, message: "Use `init(temperature: , date: )` instead")
    convenience init() {
        self.init(temperature: "", date: Date(), iconSource: nil)
    }
    
    @available(*, unavailable, message: "Use `init(temperature: , date: )` instead")
    override convenience init(frame: CGRect) {
        self.init(temperature: "", date: Date(), iconSource: nil)
    }
    
    @available(*, unavailable, message: "Use `init(temperature: , date: )` instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(dateLabel)
        containerStackView.addArrangedSubview(temperatureLabel)
        containerStackView.addArrangedSubview(conditionImageView)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            conditionImageView.heightAnchor.constraint(equalToConstant: 28),
            conditionImageView.widthAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configure() {
        dateLabel.text = self.date.toString(withFormat: DateUtils.MMMdEEE)
        temperatureLabel.text = "\(self.temperature)"
        conditionImageView.kf.setImage(with: self.iconSource)
    }
    
    func reconfigure(temperature: String, date: Date, iconSource: Source? = nil) {
        self.temperature = temperature
        self.date = date
        self.iconSource = iconSource
        self.configure()
    }
}
