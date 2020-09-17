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

    let apiURL: String = "https://api.covid19api.com/summary"

    var delegate: ApiManagerDelegate?


    func fetchStats()  {

        let urlString = "\(apiURL)"
        performRequest(urlString: urlString)

    }

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
                    print(info)
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
            let confirmed = decodedData.Global.TotalConfirmed
            let deaths = decodedData.Global.TotalDeaths

            var allLocations = [CovidModel]()

            for location in decodedData.Countries {
                var countryStat = CovidModel(country: "", countryConfirmed: 0, countryDeaths: 0)

                countryStat.country = location.Country
            //  countryStat.country_population = location.country_population ?? 0
                countryStat.countryConfirmed = location.TotalConfirmed
                countryStat.countryDeaths = location.TotalDeaths

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
