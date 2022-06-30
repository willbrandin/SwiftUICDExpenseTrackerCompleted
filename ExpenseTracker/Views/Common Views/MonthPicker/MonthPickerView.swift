//
//  MonthPickerView.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MonthPickerView: View {
    var monthOptions: [String]
    @Binding var selection: [Int]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(monthOptions.indices, id: \.self) { month in
                    Button(action: { setSelection(month) }) {
                        MonthPickerItem(
                            title: monthOptions[month],
                            isSelected: selection.contains(month)
                        )
                    }
                    .foregroundColor(selection.contains(month) ? .blue : .secondary)
                }
            }
            .padding()
        }
    }
    
    private func setSelection(_ month: Int) {
        if selection.contains(month) {
            selection.removeAll { $0 == month }
        } else {
            selection.append(month)
        }
    }
}

struct MonthPickerView_Previews: PreviewProvider {
    
    struct MonthlyPickerPreview: View {
        @State var selection: [Int] = []
        var body: some View {
            MonthPickerView(
                monthOptions: Current.calendar().shortMonthSymbols,
                selection: $selection
            )
        }
    }
    
    static var previews: some View {
        MonthlyPickerPreview()
            .previewLayout(.sizeThatFits)
    }
}
