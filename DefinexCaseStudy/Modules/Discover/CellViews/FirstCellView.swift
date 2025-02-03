//
//  FirstCellView.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import SDWebImage


class FirstCellView: UICollectionViewCell {
    static let identifier = "FirstCellView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Little Black Book For Perfect Reading")
        label.font = Typography.subheading()
        label.numberOfLines = 2
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.subheading()
        label.attributedText = NSAttributedString(string: "$19.99")
        return label
    }()
    
    private let oldPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.font = Typography.medium()
        label.attributedText = NSAttributedString(string: "$39.99", attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        return label
    }()
    
    private let discountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        label.text = "48% OFF"
        label.font = Typography.medium()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        let discountStackView = UIStackView(arrangedSubviews: [oldPriceLabel, discountLabel])
        discountStackView.axis = .horizontal
        discountStackView.spacing = 10
        discountStackView.distribution = .fillProportionally
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
        ])
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, priceLabel, discountStackView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: DiscoverListResponse) {
        titleLabel.text = product.description
        priceLabel.text = "\(product.price.value)" + " " +  (product.price.currency) + "US"
        if let oldPrice = product.oldPrice {
            oldPriceLabel.text = "\(oldPrice.value)" + " " +  (oldPrice.currency) + "US"
        } else {
            oldPriceLabel.text = "No price available"
        }
        
        discountLabel.text = product.discount
        if let url = URL(string: product.imageUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
    
    
    
}
