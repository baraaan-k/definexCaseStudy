//
//  DiscoverEntity.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation



struct DiscoverResponse: Codable {
    let isSuccess: Bool
    let message: String
    let statusCode: String?
    let list: [DiscoverListResponse]
}


struct DiscoverListResponse: Codable {
    let imageUrl: String
    let description: String
    let price: Price
    let oldPrice: Price?
    let discount: String
    let ratePercentage: Int?
}


struct Price: Codable {
    let value: Double
    let currency: String
}
