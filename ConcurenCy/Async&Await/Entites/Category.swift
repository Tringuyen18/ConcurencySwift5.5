//
//  Category.swift
//  Category
//
//  Created by Nguyễn Trí on 28/08/2021.
//

import Foundation

struct Category: Codable, Hashable {
    var strCategory: String
}

struct CategoryResult: Codable {
    var drinks: [Category]
}
