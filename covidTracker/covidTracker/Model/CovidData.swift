//
//  CovidData.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 5/5/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import Foundation

struct CovidData: Codable {
    let Global: Global
    let Countries: [Countries]

}

struct Global: Codable {
    let TotalConfirmed: Int
    let TotalDeaths: Int
}

struct Countries: Codable {
    let Country: String
    let TotalConfirmed: Int
    let TotalDeaths: Int

}
