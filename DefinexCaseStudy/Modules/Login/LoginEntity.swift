//
//  LoginEntity.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation

struct LoginResponse: Codable {
    let isSuccess: Bool
    let message: String
    let token: String 
}



