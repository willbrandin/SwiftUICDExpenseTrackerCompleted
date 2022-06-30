//
//  LogRowItem.swift
//  ExpenseTracker
//
//  Created by Will Brandin on 6/30/22.
//  Copyright © 2022 Alfian Losari. All rights reserved.
//

import SwiftUI

struct LogRowItemContent {
    var category: Category
    var name: String
    var date: String
    var amount: String
}

extension LogRowItemContent {
    init(log: ExpenseLog) {
        self.category = log.categoryEnum
        self.name = log.nameText
        self.date = log.dateText
        self.amount = log.amountText
    }
}

struct LogRowItem: View {
    var content: LogRowItemContent
    
    var body: some View {
        HStack(spacing: 16) {
            CategoryImageView(category: content.category)

            VStack(alignment: .leading, spacing: 8) {
                Text(content.name)
                    .font(.headline)
                Text(content.date)
                    .font(.subheadline)
            }
            Spacer()
            Text(content.amount)
                .font(.headline)
        }
    }
}

extension LogRowItem {
    init(log: ExpenseLog) {
        self.init(content: LogRowItemContent(log: log))
    }
}

struct LogRowItem_Previews: PreviewProvider {
    static var previews: some View {
        LogRowItem(
            content: LogRowItemContent(
                category: .health,
                name: "ROBITUSSIN ",
                date: "10 days ago",
                amount: "$5.50"
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
