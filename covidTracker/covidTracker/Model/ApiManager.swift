//
//  ApiManager.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 5/5/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import Foundation


protocol ApiManagerDelegate {
   // func didUpdateStats(_ apiManager: ApiManager, stats: [CovidModel])
    func didUpdateLatest(_ apiManager: ApiManager, stats: CovidLatestModel, countries: [CovidModel] )
    func didFailWithError(error: Error)

}

struct ApiManager {

    let apiURL: String = "https://coronavirus-tracker-api.herokuapp.com/v2/"

    var delegate: ApiManagerDelegate?


    func fetchStats()  {
//        let urlString = "\(apiURL)locations?country=\(country)"
        let urlString = "\(apiURL)locations"
        print(urlString)
        performRequest(urlString: urlString)

    }

//    func fetchAllStats() {
//        let urlString = "\(apiURL)locations"
//        performRequest(urlString: urlString, withLatest: false)
//    }
//
//    func fetchLatestStats() {
//        let urlString = "\(apiURL)locations"
//        performRequest(urlString: urlString, withLatest: true)
//    }

//    func performRequest(urlString: String, withLatest: Bool = false) {
//
//        if let url = URL(string: urlString) {
//
//            let session = URLSession(configuration: .default)
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if  error != nil {
//                    self.delegate?.didFailWithError(error: error!)
//                    print("There was an error \(error!)")
//                }
//
//                if let safeData = data {
//                    if !withLatest {
//                        if let info = self.parseJSON(with: safeData, withLatest: withLatest) {
//                            if let covidStats = info as? [CovidModel] {
//                                self.delegate?.didUpdateStats(self, stats: covidStats)
//                            }
//                        }
//                    } else {
//                        if let info = self.parseJSON(with: safeData, withLatest: withLatest) {
//                            if let covidLatestStats = info as? CovidLatestModel {
//                            self.delegate?.didUpdateLatest(self, stats: covidLatestStats)
//                            }
//                        }
//                    }
//
//                    print(safeData)
//                }
//
////                if let sessResponse = response {
////                  //  print("session response: \(sessResponse)")
////                }
//            }
//            task.resume()
//        }
//
//    }

    func performRequest(urlString: String) {

        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                     self.delegate?.didFailWithError(error: error!)
                     print("There was an error \(error!)")
                }

                if let safeData = data {
                     let info = self.parseJSON(with: safeData)
                     let latestData = info.latest
                    let allcountries = info.allLocations
                    self.delegate?.didUpdateLatest(self, stats: latestData!, countries: allcountries! )
                //    self.delegate?.didUpdateStats(self, stats: allcountries!)

                }
            }
            task.resume()
        }

    }

    func parseJSON(with covidData: Data) -> (allLocations: [CovidModel]?, latest: CovidLatestModel?) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CovidData.self, from: covidData)
            let confirmed = decodedData.latest.confirmed
            let deaths = decodedData.latest.deaths

            var allLocations = [CovidModel]()

            for location in decodedData.locations {
                var countryStat = CovidModel(country: "", countryConfirmed: 0, countryDeaths: 0, country_population: 0)

                countryStat.country = location.country
                countryStat.country_population = location.country_population ?? 0
                countryStat.countryConfirmed = location.latest.confirmed
                countryStat.countryDeaths = location.latest.deaths

                allLocations.append(countryStat)
            }

//            let countryConfirmed = decodedData.locations[0].latest.confirmed
//            let countryDeaths = decodedData.locations[0].latest.deaths
            let covidLatestModel = CovidLatestModel(confirmed: confirmed, deaths: deaths)


                return (allLocations, covidLatestModel)

        } catch {
           delegate?.didFailWithError(error: error)
           // print("Error parsing JSON")
            return (nil, nil)
        }

    }
}
