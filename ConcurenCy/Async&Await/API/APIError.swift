//
//  APIError.swift
//  APIError
//
//  Created by Nguyễn Trí on 28/08/2021.
//

import Foundation

enum APIError: Error {
    
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .error(let string):
            return string
        }
    }
}
