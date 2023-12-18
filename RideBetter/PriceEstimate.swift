//
//  PriceEstimate.swift
//  RideBetter
//
//  Created by Maryam Afshar on 2023-06-23.
//

import Foundation

struct UberPriceEstimateResponse: Codable {
    let prices: [UberPriceEstimate]
}

struct UberPriceEstimate: Codable {
    let localizedDisplayName: String
    let estimate: String
    // Add other necessary properties as needed
}
