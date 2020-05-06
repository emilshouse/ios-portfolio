//
//  ApiManager.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 5/5/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import Foundation


protocol ApiManagerDelegate {
    func didUpdateStats(_ apiManager: ApiManager, stats: CovidModel)
    func didFailWithError(error: Error)

}



struct ApiManager {

    let apiURL: String = "https://coronavirus-tracker-api.herokuapp.com/v2/"

    var delegate: ApiManagerDelegate?


    func fetchStats()  {
        let urlString = "\(apiURL)/latest"
        performRequest(urlString: urlString)

    }

    func performRequest(urlString: String) {

        if let url = URL(string: urlString) {

            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if  error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("There was an error \(error!)")
                }

                if let safeData = data {
                    if let covidStats = self.parseJSON(with: safeData) {
                        self.delegate?.didUpdateStats(self, stats: covidStats)

                    }
                    print(safeData)
                }


            }
            task.resume()
        }


    }

    func parseJSON(with covidData: Data ) -> CovidModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidData.self, from: covidData)
            print("decoded Data \(decodedData)")
            let confirmed = decodedData.latest.confirmed
            print(confirmed)
            let deaths = decodedData.latest.deaths

            let covidModel = CovidModel(confirmed: confirmed, deaths: deaths)
            return covidModel

        } catch {
           delegate?.didFailWithError(error: error)
           // print("Error parsing JSON")
            return nil
        }


    }
}
