//
//  Currency.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import Combine
import Foundation

enum Currency: String, Codable {
    case usd = "USD"
    case eur = "EUR"
    
    var emoji: String {
        switch self {
        case .usd:
            return "🇺🇸"
        case .eur:
            return "🇪🇺"
        }
    }
}

struct CurrencyConversionRequest: Codable {
    var amount: Double = 22.25
    var toCurrency: Currency
    var fromCurrency: Currency
    
    enum CodingKeys: String, CodingKey {
        case amount
        case toCurrency = "to_currency"
        case fromCurrency = "from_currency"
    }
    
    var httpRequest: URLRequest {
        guard let url = URL(string: "https://elementsofdesign.api.stdlib.com/aavia-currency-converter@dev/")
        else { fatalError("Unable to create URL") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder().encode(self)
        // Failing to set content in header results in Response error
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        return request
    }
}

struct CurrencyConversionResponse: Codable {
    var amount: Double
    var rate: Double
}

class CurrencyConvertor: ObservableObject {
    @Published var currency: Currency = .usd
    @Published var currencyMultiplier: Double = 1
    @Published var isRequestInFlight = false

    private var cancellable: AnyCancellable?

    func convertCurrency(_ request: CurrencyConversionRequest) {
        self.isRequestInFlight = true
        
        self.cancellable = Current.api
            .requestCurrency(request)
            .sink(
                receiveCompletion: { result in
                    self.isRequestInFlight = false

                    switch result {
                    case let .failure(error):
                        print(error.localizedDescription)
                    case .finished:
                        self.currency = request.toCurrency
                    }
                },
                receiveValue: { response in
                    self.currencyMultiplier = response.rate
                }
            )
    }
}
