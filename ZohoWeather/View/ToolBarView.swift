//
//  ToolBarView.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import Foundation
import UIKit

protocol ToolBarDelegate: AnyObject {
    func didTapRefresh()
    func didTapSettings()
    func didTapSearch()
}

class ToolBarView: UIView {
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: ToolBarDelegate?
    
    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    @available(*, unavailable, message: "Use `init` instead")
    override convenience init(frame: CGRect) {
        self.init()
    }
    
    @available(*, unavailable, message: "Use `init` instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(city: String) {
        self.locationLabel.text = city
    }
    
    private func setupView() {
        addSubview(settingsButton)
        addSubview(locationLabel)
        addSubview(refreshButton)
        addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            settingsButton.topAnchor.constraint(equalTo: self.topAnchor),
            settingsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            settingsButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            settingsButton.widthAnchor.constraint(equalToConstant: 24),
            settingsButton.heightAnchor.constraint(equalToConstant: 24),
            
            searchButton.topAnchor.constraint(equalTo: self.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),
            
            refreshButton.topAnchor.constraint(equalTo: self.topAnchor),
            refreshButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            refreshButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -8),
            refreshButton.widthAnchor.constraint(equalToConstant: 24),
            refreshButton.heightAnchor.constraint(equalToConstant: 24),
            
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: settingsButton.trailingAnchor)
        ])
        
        settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        refreshButton.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapRefreshButton(_ sender: UIButton) {
        delegate?.didTapRefresh()
    }
    
    @objc
    private func didTapSettingsButton(_ sender: UIButton) {
        delegate?.didTapSettings()
    }
    
    @objc
    private func didTapSearchButton(_ sender: UIButton) {
        delegate?.didTapSearch()
    }
    
}
