//
//  DetailViewController.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 9/23/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var countryStats = CovidModel()
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var newCasesLabel: UILabel!
    @IBOutlet weak var totalCasesLabel: UILabel!
    @IBOutlet weak var newDeathsLabel: UILabel!
    @IBOutlet weak var totalDeathsLabel: UILabel!
    @IBOutlet weak var newRecoveredLabel: UILabel!
    @IBOutlet weak var totalRecoveredLabel: UILabel!

    @IBAction func dismissButton(_ sender: UIButton) {
        self.remove()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.cornerRadius = 12
        self.view.layer.masksToBounds = true

        countryLabel.text = "Country: " + countryStats.country
        newCasesLabel.text = "New Confirmed: " + String(countryStats.newConfirmed.withCommas())
        totalCasesLabel.text = "Total Confirmed: " + String(countryStats.totalConfirmed.withCommas())
        newDeathsLabel.text = "New Deaths: " + String(countryStats.newDeaths.withCommas())
        totalDeathsLabel.text = "Total Deaths: " + String(countryStats.totalDeaths.withCommas())
        newRecoveredLabel.text = "New Recovered: " + String(countryStats.newRecovered.withCommas())
        totalRecoveredLabel.text = "Total Recovered: " +  String(countryStats.totalRecovered.withCommas())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
