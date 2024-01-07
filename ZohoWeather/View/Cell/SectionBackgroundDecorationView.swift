//
//  SectionBackgroundDecorationView.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation
import UIKit

import UIKit

class SectionBackgroundDecorationView: UICollectionReusableView {
    static let reuseID = "bgDecorationView"
    
    private let visualEffectView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .light)
        return UIVisualEffectView(effect: effect)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    func configure() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.layer.masksToBounds = true
        visualEffectView.layer.cornerRadius = 12
        addSubview(visualEffectView)
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        layer.cornerRadius = 12
    }
}

