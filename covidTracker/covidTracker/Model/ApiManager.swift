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
    func didUpdateLatest(_ apiManager: ApiManager, stats: CovidLatestModel)
    func didFailWithError(error: Error)

}

struct ApiManager {

    let apiURL: String = "https://coronavirus-tracker-api.herokuapp.com/v2/"

    var delegate: ApiManagerDelegate?


    func fetchStats(with country: String)  {
        let urlString = "\(apiURL)locations?country=\(country)"
        print(urlString)
        performRequest(urlString: urlString)

    }

    func fetchLatestStats() {
        let urlString = "\(apiURL)latest"
        performRequest(urlString: urlString, withLatest: true)
    }

    func performRequest(urlString: String, withLatest: Bool = false) {

        if let url = URL(string: urlString) {

            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if  error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print("There was an error \(error!)")
                }

                if let safeData = data {
                    if !withLatest {
                        if let info = self.parseJSON(with: safeData, withLatest: withLatest) {
                            if let covidStats = info as? CovidModel {
                                self.delegate?.didUpdateStats(self, stats: covidStats)
                            }
                        }
                    } else {
                        if let info = self.parseJSON(with: safeData, withLatest: withLatest) {
                            if let covidLatestStats = info as? CovidLatestModel {
                            self.delegate?.didUpdateLatest(self, stats: covidLatestStats)
                            }
                        }
                    }

                    print(safeData)
                }

//                if let sessResponse = response {
//                  //  print("session response: \(sessResponse)")
//                }
            }
            task.resume()
        }

    }

    func parseJSON(with covidData: Data, withLatest: Bool ) -> Any? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidData.self, from: covidData)
            let confirmed = decodedData.latest.confirmed
            let deaths = decodedData.latest.deaths

//            let countryConfirmed = decodedData.locations[0].latest.confirmed
//            let countryDeaths = decodedData.locations[0].latest.deaths

            if !withLatest {
                let covidModel = CovidModel(country: nil, countryConfirmed: confirmed, countryDeaths: deaths)
                return covidModel
            } else {
                let covidLatestModel = CovidLatestModel(confirmed: confirmed, deaths: deaths)
                return covidLatestModel
            }

        } catch {
           delegate?.didFailWithError(error: error)
           // print("Error parsing JSON")
            return nil
        }

    }
}
