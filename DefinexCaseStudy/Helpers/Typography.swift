//
//  Typography.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import UIKit

struct Typography {
    
    static func regularFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func headling() -> UIFont {
        return regularFont(size: 24)
    }
    
    static func title() -> UIFont {
        return regularFont(size: 20)
    }
    
    static func subheading() -> UIFont {
        return regularFont(size: 16)
    }
    
    static func medium() -> UIFont {
        return regularFont(size: 14)
    }
    
    static func regular() -> UIFont {
        return regularFont(size: 12)
    }
    
    static func minicaps() -> UIFont {
        return regularFont(size: 10)
    }
}
