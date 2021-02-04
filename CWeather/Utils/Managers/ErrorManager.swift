//
//  ErrorManager.swift
//  CWeather
//
//  Created by vlsuv on 04.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

enum ErrorManager: Error {
    case MissingHTTPResponceError
    case ParseJSONError
}

extension ErrorManager {
    var description: String {
        switch self {
        case .MissingHTTPResponceError:
            return NSLocalizedString("MissingHTTPResponceError", comment: "")
        case .ParseJSONError:
            return NSLocalizedString("ParseJSONError", comment: "")
        }
    }
}
