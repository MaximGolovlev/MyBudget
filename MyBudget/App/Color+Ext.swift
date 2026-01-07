//
//  Color+Ext.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//

import SwiftUI

extension Color {
    // Transaction type colors
    static let incomeGreen = Color(red: 0.2, green: 0.8, blue: 0.2)
    static let expenseRed = Color(red: 1.0, green: 0.4, blue: 0.4)
    
    // Category colors for pie chart
    static let category1 = Color(red: 0.2, green: 0.6, blue: 1.0)    // Salary - Blue
    static let category2 = Color(red: 1.0, green: 0.6, blue: 0.2)    // Freelance - Orange
    static let category3 = Color(red: 0.4, green: 0.8, blue: 0.6)    // Investment - Teal
    static let category4 = Color(red: 1.0, green: 0.8, blue: 0.2)    // Food - Yellow
    static let category5 = Color(red: 0.8, green: 0.4, blue: 1.0)    // Transportation - Purple
    static let category6 = Color(red: 1.0, green: 0.4, blue: 0.6)    // Shopping - Pink
    static let category7 = Color(red: 0.6, green: 0.8, blue: 0.2)    // Entertainment - Lime
    static let category8 = Color(red: 0.4, green: 0.6, blue: 0.8)    // Utilities - Light Blue
    static let category9 = Color(red: 1.0, green: 0.6, blue: 0.8)    // Health - Light Pink
    static let category10 = Color(red: 0.8, green: 0.8, blue: 0.4)   // Education - Olive
    static let category11 = Color(red: 0.7, green: 0.7, blue: 0.7)   // Other - Gray
}

extension Color {
    init(_ name: String) {
        switch name {
        case "incomeGreen": self = .incomeGreen
        case "expenseRed": self = .expenseRed
        case "category1": self = .category1
        case "category2": self = .category2
        case "category3": self = .category3
        case "category4": self = .category4
        case "category5": self = .category5
        case "category6": self = .category6
        case "category7": self = .category7
        case "category8": self = .category8
        case "category9": self = .category9
        case "category10": self = .category10
        case "category11": self = .category11
        default: self = .gray
        }
    }
}
