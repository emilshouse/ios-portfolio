//
//  CovidData.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 5/5/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import Foundation
// swiftlint:disable all
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
    let NewConfirmed: Int
    let TotalConfirmed: Int
    let NewDeaths: Int
    let TotalDeaths: Int
    let NewRecovered: Int
    let TotalRecovered: Int

}
