//
//  CovidData.swift
//  covidTracker
//
//  Created by Adnan Abdulai on 5/5/20.
//  Copyright © 2020 Adnan Abdulai. All rights reserved.
//

import Foundation

struct CovidData: Codable {
    let latest: Latest
    
   // let locations: [Location]
  //  let timeline: Timeline
}


//struct Location: Codable {
//    let id: Int
//    let country: String
//    let latest: Latest
//    
//}

struct Latest: Codable {
    let confirmed: Int
    let deaths: Int
    let recovered: Int
}

