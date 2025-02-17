//
//  DashboardTabView.swift
//  ExpenseTracker
//
//  Created by Alfian Losari on 19/04/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import CoreData
import SwiftUI

struct DashboardTabView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Double?
    @State var categoriesSum: [CategorySum]?
    @ObservedObject var currencyConvertor = CurrencyConvertor()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: 4) {
                    if totalExpenses != nil {
                        Text("Total expenses")
                            .font(.headline)
                        if totalExpenses != nil {
                            Text(
                                currencyConvertor.localizedCurrency(totalExpenses ?? 0)
                            )
                            .font(.largeTitle)
                        }
                    }
                }
                
                if categoriesSum != nil {
                    if totalExpenses != nil && totalExpenses! > 0 {
                        PieChartView(
                            data: categoriesSum!.map { ($0.sum, $0.category.color) },
                            style: Styles.pieChartStyleOne,
                            form: CGSize(width: 300, height: 240),
                            dropShadow: false
                        )
                    }
                    
                    Divider()

                    List {
                        Text("Breakdown").font(.headline)
                        ForEach(self.categoriesSum!) {
                            CategoryRowView(
                                category: $0.category,
                                sum: currencyConvertor.localizedCurrency($0.sum)
                            )
                        }
                    }
                }
                
                if totalExpenses == nil && categoriesSum == nil {
                    Text("No expenses data\nPlease add your expenses from the logs tab")
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.horizontal)
                }
            }
            .padding(.top)
            .onAppear(perform: fetchTotalSums)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    CurrencyButton(
                        isLoading: currencyConvertor.isRequestInFlight,
                        currency: $currencyConvertor.currency,
                        onTapAction: toggleCurrencyRequest
                    )
                    .padding()
                }
            }
        }
    }
    
    func toggleCurrencyRequest() {
        let request = CurrencyConversionRequest(
            toCurrency: currencyConvertor.currency == .usd ? .eur : .usd,
            fromCurrency: currencyConvertor.currency
        )
        
        self.currencyConvertor.convertCurrency(request)
    }
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else { return }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }
}


struct CategorySum: Identifiable, Equatable {
    let sum: Double
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}


struct DashboardTabView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabView()
    }
}
