//
//  FlagViewController.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 1/16/20.
//  Copyright © 2020 Lilia Yudina. All rights reserved.
//

import UIKit

class FlagViewController: UIViewController {
    
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var flagImage = [CountryData]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    var searchQuery = "" {
        didSet {
            CountryAPIClient.getCountry { (result) in
                switch result {
                case .failure(let error):
                    print("failure: \(error)")
                case .success(let countries):
                    self.flagImage = countries.filter{$0.name.lowercased().contains(self.searchQuery.lowercased())}
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        loadCountries()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController, let indexPath = collectionView.indexPathsForSelectedItems else {
            fatalError("failed to get indexPath and DetailViewController")
        }
        let chosenFlag = flagImage[indexPath.first!.row]
        detailViewController.country = chosenFlag
        
    }
    
    func filterCountries (for searchText: String) {
        guard !searchText.isEmpty else {return}
        CountryAPIClient.getCountry { (result) in
            switch result {
                case .failure(let error):
                print("appError: \(error)")
           case .success(let countries):
           self.flagImage = countries.filter{$0.name.lowercased().contains(self.searchQuery.lowercased())}
            }
        }
    }
    
    func loadCountries () {
        CountryAPIClient.getCountry { (result) in
            switch result {
            case .failure(let appError):
                print("appError: \(appError)")
            case .success(let countries):
                self.flagImage = countries
            }
        }
    }
    
}
extension FlagViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flagImage.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "flagCell", for: indexPath) as? FlagCell else {
            fatalError("Couldn't dequeue the FlagCell")
        }
        let flagImages = flagImage[indexPath.row]
        cell.configureCell(for: flagImages)
        return cell
    }
}

extension FlagViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 10
        let maxWidth = UIScreen.main.bounds.size.width
        let numberOfItems: CGFloat = 3
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 5, right: 10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}


extension FlagViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
           searchBar.resignFirstResponder()
        guard let searchText = searchBar.text else {return}
        filterCountries(for: searchText)
       }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            loadCountries()
            return
        }
        
        searchQuery = searchText.lowercased()
        
    }
}
