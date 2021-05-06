//
//  EarthImage.swift
//  DailyEarthImageAPIApp
//
//  Created by Justin Webster on 5/5/21.
//

import Foundation

struct TopLevelObject: Codable {
    
    let photodata: [EarthImage]
}

struct EarthImage: Codable {
    
    let image: String?
    let date: String?
    let caption: String?
}
