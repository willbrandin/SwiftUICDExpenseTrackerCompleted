//
//  CurrencyButton.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct CurrencyButton: View {
    var isLoading: Bool = false
    @Binding var currency: Currency
    var onTapAction: () -> Void = {}
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                Button(action: onTapAction) {
                    Text(currency.emoji)
                }
            }
        }
        .frame(width: 24, height: 24)
        .padding()
        .background(Color(uiColor: .tertiarySystemBackground))
        .clipShape(Circle())
        .padding()
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        .allowsHitTesting(!isLoading)
    }
}

struct CurrencyButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CurrencyButton(currency: .constant(.usd))
            CurrencyButton(currency: .constant(.eur))
            CurrencyButton(isLoading: true, currency: .constant(.eur))
        }
        .previewLayout(.sizeThatFits)
    }
}
