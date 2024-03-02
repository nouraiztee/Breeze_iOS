//
//  ViewController.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 01/03/2024.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var todayWeatherIcon: UIImageView!
    @IBOutlet weak var todayWeather: UILabel!
    
    @IBOutlet weak var dayOneLbl: UILabel!
    @IBOutlet weak var dayTwoLbl: UILabel!
    @IBOutlet weak var dayThreeLbl: UILabel!
    
    @IBOutlet weak var dayOneIcon: UIImageView!
    @IBOutlet weak var dayTwoIcon: UIImageView!
    @IBOutlet weak var dayThreeIcon: UIImageView!
    
    @IBOutlet weak var dayOneTemp: UILabel!
    @IBOutlet weak var dayTwoTemp: UILabel!
    @IBOutlet weak var dayThreeTemp: UILabel!
    
    let apiService = APIService()
    var viewModel: CurrentWeatherViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setGradiantBG(startColor: .gradiantBGStart , endColor: .gradiantBGEnd)
        
        viewModel = CurrentWeatherViewModel(apiServices: apiService)
        viewModel?.viewDelegate = self
        viewModel?.getCurrentWeatherData(forLocation: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar()
    }

    
    private func setNavBar() {
        setNavBar(title: viewModel?.getCurrentLocationName() ?? "Cuppertino, CA")
        setNavBarButtons()
    }
    
    private func setNavBar(title: String) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = title
    }
    
    private func setNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchTapped))
        
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    private func setGradiantBG(startColor: UIColor, endColor: UIColor){
        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        // Set the frame to the layer
        gradientLayer.frame = view.frame
        
        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc func refreshTapped(sender: UIBarButtonItem) {
        let currentLocationCordinate = viewModel?.getCurrentLocationLatLong() ?? ""
        
        viewModel?.getWeatherInfo(forLocation: currentLocationCordinate)
    }
    
    @objc func searchTapped(sender: UIBarButtonItem) {
        let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationViewController") as! SearchLocationViewController
        searchVC.didSelectLocation = { [weak self] (lat, lon) in
            self?.viewModel?.getWeatherInfo(forLocation: "\(lat), \(lon)")
        }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }

}

extension LandingViewController: LandingViewControllerDelegate {
    func didGetWeather(data: WeatherResponseModel) {
        let currentWeather = viewModel?.getCurrentWeather()
        let forecast = viewModel?.getForeCastWeather()
        let location = viewModel?.getCurrentLocationName() ?? ""
        
        DispatchQueue.main.async {
            self.setNavBar(title: location)
            
            self.todayWeather.text = currentWeather?.temp
            self.todayWeatherIcon.image = UIImage(systemName: currentWeather?.icon ?? "")?.withRenderingMode(.alwaysOriginal)
            
            [self.dayOneTemp, self.dayTwoTemp, self.dayThreeTemp].enumerated().forEach { (index, label) in
                label.text = forecast?[index].temp
            }
            [self.dayOneIcon, self.dayTwoIcon, self.dayThreeIcon].enumerated().forEach { (index, imageView) in
                imageView?.image = UIImage(systemName: forecast?[index].icon ?? "")?.withRenderingMode(.alwaysOriginal)
                
            }
            
            let daysOfWeek = self.viewModel?.getDays()
            [self.dayOneLbl, self.dayTwoLbl, self.dayThreeLbl].enumerated().forEach { (index, label) in
                label?.text = daysOfWeek?[index].uppercased()
            }
        }
        
    }
    
    func didFailToGetWeather(withError error: Error) {
        let dialogMessage = UIAlertController(title: "Opps an error occured", message: error.localizedDescription, preferredStyle: .alert)
        // Present alert to user
        self.present(dialogMessage, animated: true, completion: nil)
    }
}

