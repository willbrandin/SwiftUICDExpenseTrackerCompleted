//
//  MonthlySummaryTabView.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//
import CoreData

import SwiftUI

struct MonthlySummaryTabView: View {
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)]
    )
    private var items: FetchedResults<ExpenseLog>
    
    @State var selectedMonths: [Int] = []
    
    var monthOptions: [String] {
        Current.calendar().shortMonthSymbols
    }
    
    var noSelectionContent: some View {
        VStack {
            Text("Give that picker a tappy and see some magic.")
                .font(.subheadline.monospaced())
                .multilineTextAlignment(.center)
                .lineSpacing(8)
            
            Spacer()
        }
    }
    
    var logListContent: some View {
        List(logsFiltered(with: selectedMonths)) { item in
            LogRowItem(log: item)
                .padding(.vertical, 4)
        }
    }
    
    var emptySelectionContent: some View {
        VStack {
            Text("Hmm, there's nothing here. Let's try another.")
                .font(.subheadline.monospaced())
                .multilineTextAlignment(.center)
                .lineSpacing(8)
            
            Spacer()
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            MonthPickerView(
                monthOptions: monthOptions,
                selection: $selectedMonths
            )
            
            if selectedMonths.isEmpty {
                noSelectionContent
            } else if logsFiltered(with: selectedMonths).isEmpty {
                emptySelectionContent
            } else {
                logListContent
            }
        }
    }
    
    func selectionContains(log: ExpenseLog, selection: [Int]) -> Bool {
        guard let logDate = log.date else { return false }
        
        guard let logMonth = Current
            .calendar()
            .dateComponents([.month], from: logDate)
            .month
        else { return false }
        
        let zeroIndexMonth = logMonth - 1
        
        return selection.contains(zeroIndexMonth)
    }
    
    func logsFiltered(with selection: [Int]) -> [ExpenseLog] {
        return items
            .filter { selectionContains(log: $0, selection: selection) }
    }
}

struct MonthlySummaryTabView_Previews: PreviewProvider {
    static var previews: some View {
        MonthlySummaryTabView()
    }
}
