//
//  SearchResponseModel.swift
//  Breeze
//
//  Created by Nouraiz Taimour on 02/03/2024.
//

import Foundation

// MARK: - SearchResponseModel
struct SearchResponseModel: Codable {
    let id: Int
    let name, region, country: String
    let lat, lon: Double
    let url: String
}
