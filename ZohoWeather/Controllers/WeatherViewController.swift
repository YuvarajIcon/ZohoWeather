//
//  WeatherViewController.swift
//  ZohoWeather
//
//  Created by Yuvaraj Selvam on 06/01/24.
//

import UIKit
import Alamofire
import CoreLocation

/**
 WeatherViewController

 A view controller displaying weather information, including the current weather, forecast, and additional details.
 */
class WeatherViewController: BaseViewController {
    // MARK: - Properties
    private lazy var containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "background")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var weatherView: LargeWeatherView = {
        let view = LargeWeatherView(temperature: "", conditionDescription: "", iconSource: nil)
        return view
    }()
    
    private lazy var toolbar: ToolBarView = {
        let view = ToolBarView()
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        return collection
    }()
    
    private let currentWeatherVM: WeatherViewModel
    private let locationManager: LocationManager
    private var dataSource: UICollectionViewDiffableDataSource<WeatherSection, WeatherRow>!
    
    // MARK: - Initialization
    init(currentWeatherVM: WeatherViewModel, locationManager: LocationManager) {
        self.currentWeatherVM = currentWeatherVM
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "Use `init(currentWeatherVM: , locationManager: )` instead")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupDataSource()
        self.bindDelegates()
        self.fetchLocationAndWeather()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(backgroundImageView)
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(toolbar)
        containerStackView.addArrangedSubview(weatherView)
        containerStackView.addArrangedSubview(collectionView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func bindDelegates() {
        currentWeatherVM.delegate = self
        toolbar.delegate = self
    }

    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemWidth: NSCollectionLayoutDimension = .fractionalWidth(1)
            let itemSize = NSCollectionLayoutSize(widthDimension: itemWidth, heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

            let groupHeight: NSCollectionLayoutDimension = sectionIndex == 0 ? .absolute(48) : .absolute(60)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: groupHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .absolute(44)),
                elementKind: WeatherCollectionViewCell.reuseID.uppercased(),
                alignment: .topLeading
            )
            sectionHeader.pinToVisibleBounds = true
            
            let sectionBackgroundDecoration = NSCollectionLayoutDecorationItem.background(
                elementKind: SectionBackgroundDecorationView.reuseID)
            sectionBackgroundDecoration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            section.decorationItems = [sectionBackgroundDecoration]
            section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
            return section
        }
        layout.register(
            SectionBackgroundDecorationView.self,
            forDecorationViewOfKind: SectionBackgroundDecorationView.reuseID
        )
        return layout
    }
    
    private func setupDataSource() {
        let forecastCellRegistration = UICollectionView.CellRegistration<ForeCastCollectionViewCell, WeatherRow> { cell, indexPath, item in
            cell.configure(with: item)
        }

        let weatherCellRegistration = UICollectionView.CellRegistration<WeatherCollectionViewCell, WeatherRow> { cell, indexPath, item in
            cell.configure(with: item.value, color: .white)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <WeatherCollectionViewCell>(elementKind: WeatherCollectionViewCell.reuseID.uppercased()) {
            (supplementaryView, string, indexPath) in
            let type = self.currentWeatherVM.sections[indexPath.section].type.rawValue
            supplementaryView.configure(with: type, size: 12)
        }
        
        dataSource = UICollectionViewDiffableDataSource<WeatherSection, WeatherRow>(collectionView: collectionView) { collectionView, indexPath, item in
            switch indexPath.section {
            case 0:
                return collectionView.dequeueConfiguredReusableCell(using: forecastCellRegistration, for: indexPath, item: item)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: weatherCellRegistration, for: indexPath, item: item)
            }
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, index) in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    private func reloadDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<WeatherSection, WeatherRow>()
        snapshot.appendSections(currentWeatherVM.sections)
        currentWeatherVM.sections.forEach { section in
            snapshot.appendItems(section.rows, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func fetchLocationAndWeather() {
        Task {
            do {
                let location = try await self.locationManager.currentCity
                self.callAPI(inCity: location)
            } catch {
                self.handle(locationError: error)
            }
        }
    }
        
    private func callAPI(inCity city: String) {
        currentWeatherVM.getWeather(for: city, upto: 5)
    }
    
    private func handle(apiError error: AFError, response: ErrorResponse?) {
        guard let response else {
            presentAlert(title: "Unable to fetch weather", message: "Please ensure your internet is turned on. Then tap the reload button to try again")
            return
        }
        presentAlert(title: "Unable to fetch weather", message: response.error.message)
    }
    
    private func handle(locationError error: Error) {
        presentAlert(title: "Unable to fetch location", message: "Please ensure location and internet is turned on. Then tap the reload button to try again")
    }
}

// MARK: - CurrentWeatherUpdateReceiver Extension
extension WeatherViewController: CurrentWeatherUpdateReceiver {
    func didLoad(with currentWeather: Weather, forCity city: String) {
        toolbar.configure(city: city.uppercased())
        weatherView.reconfigure(
            temperature: "\(currentWeather.temperature)°",
            conditionDescription: currentWeather.conditionText,
            iconSource: currentWeather.iconSource
        )
        self.reloadDataSource()
    }
    
    func didFail(with error: AFError, response: ErrorResponse?) {
        handle(apiError: error, response: response)
    }
}

// MARK: - ToolBarDelegate Extension
extension WeatherViewController: ToolBarDelegate {
    func didTapSearch() {
        presentTextFieldAlert(title: "Enter a city name", message: "Enter a valid city name to look up its weather", placeholder: "Type the city name here", defaultValue: nil, completion: { [weak self] value in
            guard let value else { return }
            self?.callAPI(inCity: value)
        })
    }
    
    func didTapRefresh() {
        self.fetchLocationAndWeather()
    }
    
    func didTapSettings() {
        let settingVC = SettingsViewController()
        settingVC.delegate = self
        self.present(settingVC, animated: true)
    }
}

// MARK: - MetricUpdateReciever Extension
extension WeatherViewController: MetricUpdateReciever {
    func didChangeMetric() {
        self.fetchLocationAndWeather()
    }
}
