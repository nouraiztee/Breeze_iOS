//
//  SearchLocationViewController.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 02/03/2024.
//

import UIKit

class SearchLocationViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let apiService = APIService()
    var viewModel: SearchViewModel?
    var didSelectLocation: ((_ lat: String, _ long: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setNavBar(title: "Search Location")
        tableView.dataSource = self
        tableView.delegate = self
        
        //customizing search bar
        searchBar.searchTextField.placeholder = "Search location (name, zipcode, region, state"
        searchBar.searchTextField.becomeFirstResponder()
        
        setViewModel()
        
    }
    
    private func setViewModel() {
        viewModel = SearchViewModel(apiServices: apiService)
        //call back if response succesful
        viewModel?.SearchViewModelToController = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        //call back if response fail
        viewModel?.errorToController = { error in
            let dialogMessage = UIAlertController(title: "Opps an error occured", message: error.localizedDescription, preferredStyle: .alert)
            // Present alert to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    private func setNavBar(title: String) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = title
        
        navigationController?.navigationBar.tintColor = .black
    }

}

extension SearchLocationViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText.count < 3 {
            return
        }
        
        viewModel?.searchLocation(byString: searchText)
    }
}

extension SearchLocationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = viewModel?.getSearchedLocationText(forIndex: indexPath.row)
        
        return cell
    }
}

extension SearchLocationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coordinates = viewModel?.getLatLon(forIndex: indexPath.row)
        
        self.didSelectLocation?(coordinates?.lat ?? "0", coordinates?.lon ?? "0")
        self.navigationController?.popViewController(animated: true)
    }
}
