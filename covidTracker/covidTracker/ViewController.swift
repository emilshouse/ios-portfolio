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
    @IBOutlet weak var countryConfirmed: UILabel!
    @IBOutlet weak var countryDeaths: UILabel!
    

    let countries = ["Ghana", "Nigeria", "Togo", "Mali", "Senegal", "Cameroon"]

    var apiManager = ApiManager()

    var tableView = UITableView()



    override func viewDidLoad() {
           super.viewDidLoad()
        apiManager.delegate = self

        tableView.delegate = self
        tableView.dataSource = self

        apiManager.fetchLatestStats()

       }



   func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }



    @IBOutlet weak var countryPicker: UIPickerView!

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Ghana"
        cell.detailTextLabel?.text = "Cases: 10, Deaths: 1"
        return cell
    }
}

extension ViewController: ApiManagerDelegate {
    func didUpdateLatest(_ apiManager: ApiManager, stats: CovidLatestModel) {
        DispatchQueue.main.async {
            self.globalCases.text = "Confirmed Cases: \(String(stats.confirmed.withCommas()))"
            self.globalDeaths.text = "Deaths: \(String(stats.deaths.withCommas()))"
        }

    }

    func didUpdateStats(_ apiManager: ApiManager, stats: CovidModel) {
        DispatchQueue.main.async {

            self.countryConfirmed.text = "Confirmed Cases: \(String(stats.countryConfirmed.withCommas()))"
            self.countryDeaths.text = "Deaths: \(String(stats.countryDeaths.withCommas()))"

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
