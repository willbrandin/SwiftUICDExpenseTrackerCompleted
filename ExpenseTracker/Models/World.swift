//
//  World.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Combine
import Foundation

/// How to Control the World
///
/// https://www.pointfree.co/blog/posts/21-how-to-control-the-world
#if DEBUG
var Current = World()
#else
let Current = World()
#endif

struct World {
    var calendar: () -> Calendar = { Calendar.current }
    var api: API = .live
}

struct API {
    var requestCurrency: (CurrencyConversionRequest) -> AnyPublisher<CurrencyConversionResponse, Error>
}

extension API {
    static var live: Self {
        return Self(
            requestCurrency: { request in
                return URLSession.shared
                    .dataTaskPublisher(for: request.httpRequest)
                    .map { $0.data }
                    .decode(type: CurrencyConversionResponse.self, decoder: JSONDecoder())
                    .receive(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
        )
    }
    
    static var mocked: Self {
        return Self(
            requestCurrency: { _ in
                let random = Double.random(in: 0.8 ..< 2.0)
                let response = CurrencyConversionResponse(amount: 1000, rate: random)
                return Just(response)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
    }
}
