//
//  CacheManager.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 1.02.2025.
//

import Foundation

class CacheManager {
    static let shared = CacheManager()
    static let firstListKey = "firstListKey"
    static let secondListKey = "secondListKey"
    static let thirdListKey = "thirdListKey"
    
    
    func loadCachedList(key: String) -> [DiscoverListResponse]? {
        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                let products = try JSONDecoder().decode([DiscoverListResponse].self, from: data)
                return products
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func saveListToCache(products: [DiscoverListResponse], key: String) {
        do {
            let data = try JSONEncoder().encode(products)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Error saving to cache: \(error)")
        }
    }
}



