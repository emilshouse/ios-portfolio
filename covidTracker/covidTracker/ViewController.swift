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
        didSet {
            tableView.reloadData()
        }
    }
    
    var apiManager = ApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiManager.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        cell.detailTextLabel?.text = "Cases: \(countries[indexPath.row].totalConfirmed.withCommas()) Deaths: \(countries[indexPath.row].totalDeaths.withCommas())"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "detailView") as! DetailViewController

        detailVC.countryStats = countries[indexPath.row]
        print(detailVC.countryStats)

        self.add(detailVC)

        detailVC.view.translatesAutoresizingMaskIntoConstraints = false
        detailVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        detailVC.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 30).isActive = true
        detailVC.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30).isActive = true
        detailVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -200).isActive = true

    }
}

extension ViewController: ApiManagerDelegate {
    func didUpdateLatest(_ apiManager: ApiManager, stats: CovidLatestModel, countries: [CovidModel]) {

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
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
