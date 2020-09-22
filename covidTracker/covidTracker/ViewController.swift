//
//  ViewController.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 5/4/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var globalCases: UILabel!
    @IBOutlet weak var globalDeaths: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func reload(_ sender: UIButton) {

        print("Calling API...")
        apiManager.fetchStats()

    }
    
    var countries = [CovidModel]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    var apiManager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //    apiManager.fetchLatestStats()
        apiManager.fetchStats()
        
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.countries[indexPath.row].country
        cell.detailTextLabel?.text = "Cases: \(countries[indexPath.row].countryConfirmed.withCommas()) Deaths: \(countries[indexPath.row].countryDeaths.withCommas())"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //display detail view.
    }
}

extension ViewController: ApiManagerDelegate {
    func didUpdateLatest(_ apiManager: ApiManager, stats: CovidLatestModel,  countries: [CovidModel]) {
        DispatchQueue.main.async {
            self.globalCases.text = "Confirmed Cases: \(String(stats.confirmed.withCommas()))"
            self.globalDeaths.text = "Deaths: \(String(stats.deaths.withCommas()))"
            self.countries = countries
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
