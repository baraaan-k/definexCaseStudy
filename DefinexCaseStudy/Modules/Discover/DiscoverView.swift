//
//  DiscoverView.swift
//  DefinexCaseStudy
//
//  Created by baran kutlu on 2.02.2025.
//

import Foundation
import UIKit
import SDWebImage
import Combine

protocol DiscoverView: AnyObject {
    func displayFirstList(_ products: [DiscoverListResponse])
    func displaySecondList(_ products: [DiscoverListResponse])
    func displayThirdList(_ products: [DiscoverListResponse])
    func displayError(_ message: String)
    func stopRefreshing()
}

class DiscoverViewController: UIViewController, DiscoverView, DiscoverPresenterOutput {
    
    var refreshControl: UIRefreshControl!
    private var firstList: [DiscoverListResponse] = []
    private var secondList: [DiscoverListResponse] = []
    private var thirdList: [DiscoverListResponse] = []
    private var cancellables = Set<AnyCancellable>()
    var presenter: DiscoverPresenterInput?
    private var interactor: DiscoverInteractorInput?
    private var router: DiscoverRouterInput?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return DiscoverViewController.createLayout(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    static func createLayout(for section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 0)
            section.boundarySupplementaryItems = []
            return section
            
        case 1:
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute((UIScreen.main.bounds.width / 3) - 4), heightDimension: .absolute(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(180), heightDimension: .absolute(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 16, trailing: 0)
            section.boundarySupplementaryItems = []
            return section
            
        case 2:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(300))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 200, trailing: 0)
            section.boundarySupplementaryItems = []
            return section
            
        default:
            return NSCollectionLayoutSection(group: NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(100)), subitems: []))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        self.title = NSLocalizedString("discover", comment: "")
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)
        ]
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        
        
        assembly()
        fetchAll()
        
        NetworkManager.shared.observeNetworkConnection()
            .sink { [weak self] isConnected in
                if !isConnected {
                    self?.showNoInternetConnectionAlert()
                }
            }
            .store(in: &cancellables)
        
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(FirstCellView.self, forCellWithReuseIdentifier: FirstCellView.identifier)
        collectionView.register(SecondCellView.self, forCellWithReuseIdentifier: SecondCellView.identifier)
        collectionView.register(ThirdCellView.self, forCellWithReuseIdentifier: ThirdCellView.identifier)
        
        
    }
    
    @objc func refreshData() {
        DispatchQueue.main.async {
            self.fetchAll()
        }
        
        refreshControl.endRefreshing()
    }
    
    func stopRefreshing() {
        
    }
    
    private func assembly() {
        let interactor = DiscoverInteractor()
        let router = DiscoverRouter(viewController: self)
        let presenter = DiscoverPresenter(view: self, interactor: interactor, router: router)
        
        self.presenter = presenter
        interactor.output = presenter
        self.interactor = interactor
        self.router = router
    }
    
    func fetchAll() {
        presenter?.fetchFirst()
        presenter?.fetchSecond()
        presenter?.fetchThird()
    }
    
    
    func displayFirstList(_ products: [DiscoverListResponse]) {
        self.firstList = products
        self.collectionView.reloadData()
    }
    
    func displaySecondList(_ products: [DiscoverListResponse]) {
        self.secondList = products
        self.collectionView.reloadData()
    }
    
    func displayThirdList(_ products: [DiscoverListResponse]) {
        self.thirdList = products
        self.collectionView.reloadData()
    }
    
    func displayError(_ message: String) {
        
    }
    
    
    
    func showNoInternetConnectionAlert() {
        
        
    }
    
    
}



extension DiscoverViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return firstList.count
        case 1:
            return secondList.count
        case 2:
            
            return thirdList.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstCellView.identifier, for: indexPath) as! FirstCellView
            cell.configure(with: firstList[indexPath.row])
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondCellView.identifier, for: indexPath) as! SecondCellView
            cell.configure(with: secondList[indexPath.row])
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThirdCellView.identifier, for: indexPath) as! ThirdCellView
            cell.configure(with: thirdList[indexPath.row])
            return cell
        default:
            fatalError("Unexpected section")
        }
    }
}






