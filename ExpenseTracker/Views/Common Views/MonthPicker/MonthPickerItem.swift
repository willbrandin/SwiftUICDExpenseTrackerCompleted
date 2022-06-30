//
//  MonthPickerItem.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct MonthPickerItem: View {
    var title: String
    var isSelected: Bool
    
    var body: some View {
        Text(title)
            .font(.headline.monospaced().bold())
            .padding(.horizontal)
            .padding(.vertical, 8)
            .foregroundColor(isSelected ? .accentColor : .primary)
            .background(isSelected ? Color.gray.opacity(0.1) : .clear)
            .cornerRadius(8)
    }
}

struct MonthPickerItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MonthPickerItem(title: "MAR", isSelected: false)
            MonthPickerItem(title: "MAR", isSelected: true)
        }
        .previewLayout(.sizeThatFits)
    }
}
