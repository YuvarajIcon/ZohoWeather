//
//  WeatherCollectionViewCell.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation
import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {
    static let reuseID = "weatherCell"
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with text: String, size: CGFloat? = nil, color: UIColor = .black) {
        if let size {
            self.label.font = .systemFont(ofSize: size, weight: .bold)
        }
        self.label.textColor = color
        self.label.text = text
    }
}
