//
//  ViewController.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 5/4/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var globalCases: UILabel!
    @IBOutlet weak var globalDeaths: UILabel!
    @IBOutlet weak var countryConfirmed: UILabel!
    @IBOutlet weak var countryDeaths: UILabel!
    

    let countries = ["Ghana", "Nigeria", "Togo", "Mali", "Senegal", "Cameroon"]

    var apiManager = ApiManager()


    override func viewDidLoad() {
           super.viewDidLoad()
           countryPicker.dataSource = self
           countryPicker.delegate = self
        apiManager.delegate = self

        apiManager.fetchLatestStats()

       }



   func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return 6

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

            return countries[row] //"First \(row)"

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedRow = row
        apiManager.fetchStats(with: countries[selectedRow])

    }

    @IBOutlet weak var countryPicker: UIPickerView!

}

extension ViewController: ApiManagerDelegate {
    func didUpdateLatest(_ apiManager: ApiManager, stats: CovidLatestModel) {
        DispatchQueue.main.async {
            self.globalCases.text = "Confirmed Cases: \(String(stats.confirmed))"
            self.globalDeaths.text = "Deaths: \(String(stats.deaths))"
        }

    }

    func didUpdateStats(_ apiManager: ApiManager, stats: CovidModel) {
        DispatchQueue.main.async {

            self.countryConfirmed.text = "Confirmed Cases: \(String(stats.countryConfirmed))"
            self.countryDeaths.text = "Deaths: \(String(stats.countryDeaths))"

        }
       }

       func didFailWithError(error: Error) {
           print(error)
       }
}

