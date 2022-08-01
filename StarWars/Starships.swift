//
//  Starships.swift
//  StarWarsHilde
//
//  Created by Hanine-EXT, Ayoub (uif25188) on 22/07/2022.
//

import Foundation

// MARK: - Welcome
struct SW: Codable {
    let count: Int
    let results: [Starship]
}

// MARK: - Result
struct Starship: Codable {
    let name, model, manufacturer, cost_in_credits: String
    let length, max_atmosphering_speed, crew, passengers: String
    let cargo_capacity, consumables, hyperdrive_rating, MGLT: String
    let starship_class: String
}
