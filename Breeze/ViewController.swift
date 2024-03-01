//
//  ViewController.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 01/03/2024.
//

import UIKit

class ViewController: UIViewController {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setNavBar()
        setGradiantBG(startColor: .gradiantBGStart , endColor: .gradiantBGEnd)
    }

    
    private func setNavBar() {
        setNavBar(title: "Cuppertino, CA")
        setNavBarButtons()
    }
    
    private func setNavBar(title: String) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
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
    }
    
    @objc func searchTapped(sender: UIBarButtonItem) {
    }

}

