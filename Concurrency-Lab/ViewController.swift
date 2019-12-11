//
//  ViewController.swift
//  Concurrency-Lab
//
//  Created by Lilia Yudina on 12/10/19.
//  Copyright © 2019 Lilia Yudina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var countries = [CountryData]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
                    self.countries = countries.filter{$0.name.lowercased().contains(self.searchQuery.lowercased())}
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
         loadCountries()
    }
    
    func loadCountries () {
        CountryAPIClient.getCountry { (result) in
            switch result {
            case .failure(let appError):
                print("appError: \(appError)")
            case .success(let countries):
                self.countries = countries
            }
        }
    }
    func filterCountries (for searchText: String) {
        guard !searchText.isEmpty else {return}
        CountryAPIClient.getCountry { (result) in
            switch result {
                case .failure(let error):
                print("appError: \(error)")
           case .success(let countries):
           self.countries = countries.filter{$0.name.lowercased().contains(self.searchQuery.lowercased())}
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailViewController = segue.destination as? DetailViewController, let indexPath = tableView.indexPathForSelectedRow else {
            fatalError("failed to get indexPath and detailViewController")
        }
        let chosenCountry = countries[indexPath.row]
        detailViewController.country = chosenCountry
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as? CustomCell else {
            fatalError("Couldn't dequeue a CustomCell")
        }
        let country = countries[indexPath.row]
        cell.configureCell(for: country)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
extension ViewController: UISearchBarDelegate {
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
