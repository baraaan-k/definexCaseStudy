//
//  RaisedButton.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import UIKit
import Combine

enum CustomButtonType {
    case titleOnly
    case titleWithIconLeft
    case titleWithIconRight
}

class CustomButton: UIButton {
    
    
    var startColor: UIColor = .blue
    var endColor: UIColor = .green
    
    
    var customButtonType: CustomButtonType = .titleOnly {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // UI setup
    private func setupUI() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        updateButtonType()
    }
    
    
    private func updateButtonType() {
        var config = UIButton.Configuration.plain()
        config.imagePadding = 16
        switch customButtonType {
        case .titleOnly:
            self.imageView?.isHidden = true
            self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case .titleWithIconLeft:
            self.imageView?.isHidden = false
            config.imagePlacement = .leading
            
        case .titleWithIconRight:
            self.imageView?.isHidden = false
            config.imagePlacement = .trailing
        }
        self.configuration = config
    }
    
    
    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setGradientBackground()
    }
    
    func setImageX(_ image: UIImage) {
        self.setImage(image, for: .normal)
    }
    
    
    func setButtonTitle(_ title: String) {
        self.setTitle(title, for: .normal)
    }
    
    func setTitleColor(_ color: UIColor) {
        self.setTitleColor(color, for: .normal)
    }
    
    func setTitleFont(_ font: UIFont) {
        self.titleLabel?.font = font
    }
    
    func setButtonBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
