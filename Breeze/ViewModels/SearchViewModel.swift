//
//  SearchViewModel.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 02/03/2024.
//

import Foundation

class SearchViewModel {
    
    var apiServices: APIService
    private(set) var searchedLocations : [SearchResponseModel]? {
        didSet {
            self.SearchViewModelToController()
        }
    }
    
    var SearchViewModelToController : (() -> ()) = {}
    var errorToController : ((_ error: Error) -> ()) = {error in }
    
    init(apiServices: APIService) {
        self.apiServices = apiServices
    }
    
    func searchLocation(byString string: String) {
        apiServices.callSearchAPI(forLocation: string) { result in
            switch result {
            case .success(let response):
                self.searchedLocations = response
            case .failure(let error):
                self.errorToController(error)
            }
        }
    }
    
    func getNumberOfRows() -> Int {
        return searchedLocations?.count ?? 0
    }
    
    func getSearchedLocationText(forIndex index: Int) -> String {
        return searchedLocations?[index].name ?? ""
    }
    
    func getLatLon(forIndex index: Int) -> (lat: String, lon: String) {
        let lat = searchedLocations?[index].lat ?? 0
        let lon = searchedLocations?[index].lon ?? 0
        
        return ("\(lat)", "\(lon)")
    }
}
