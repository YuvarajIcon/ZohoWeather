//
//  SettingsViewController.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 07/01/24.
//

import Foundation
import UIKit

protocol MetricUpdateReciever: AnyObject {
    func didChangeMetric()
}

/**
 SettingsViewController

 A view controller allowing the user to configure app settings, such as temperature units.
 */
class SettingsViewController: BaseViewController {
    // MARK: - Properties
    private lazy var temperatureUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "Temperature Unit: "
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var temperatureControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [TemparatureUnit.celsius.rawValue, TemparatureUnit.fahrenheit.rawValue])
        switch Preference.shared.temperatureUnit {
        case .fahrenheit:
            control.selectedSegmentIndex = 1
        default:
            control.selectedSegmentIndex = 0
        }
        control.addTarget(self, action: #selector(didTapSwitch(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    weak var delegate: MetricUpdateReciever?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(temperatureUnitLabel)
        containerStackView.addArrangedSubview(temperatureControl)
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 48),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    @objc 
    private func didTapSwitch(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            Preference.shared.temperatureUnit = .celsius
        case 1:
            Preference.shared.temperatureUnit = .fahrenheit
        default:
            break
        }
        self.delegate?.didChangeMetric()
        self.dismiss(animated: true)
    }
}
