//
//  Drink.swift
//  Drink
//
//  Created by Nguyễn Trí on 29/08/2021.
//

import Foundation

struct Drink: Codable {
    var strDrink: String
    var strDrinkThumb: String
    var idDrink: String
}

struct DrinkResult: Codable {
    var drinks: [Drink]
}
