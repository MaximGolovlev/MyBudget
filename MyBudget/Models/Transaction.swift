//
//  Transaction.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//


import Foundation

struct Transaction: Identifiable, Codable {
    let id: UUID
    let title: String
    let amount: Double
    let type: TransactionType
    let category: Category
    let date: Date
    let isTemplate: Bool
    
    init(id: UUID = UUID(), title: String, amount: Double, type: TransactionType, category: Category, date: Date = Date(), isTemplate: Bool = false) {
        self.id = id
        self.title = title
        self.amount = amount
        self.type = type
        self.category = category
        self.date = date
        self.isTemplate = isTemplate
    }
}

enum TransactionType: String, CaseIterable, Codable {
    case income = "Income"
    case expense = "Expense"
    
    var symbol: String {
        switch self {
        case .income: return "↑"
        case .expense: return "↓"
        }
    }
    
    var color: String {
        switch self {
        case .income: return "incomeGreen"
        case .expense: return "expenseRed"
        }
    }
}

enum Category: String, CaseIterable, Codable {
    case salary = "Salary"
    case freelance = "Freelance"
    case investment = "Investment"
    case food = "Food"
    case transportation = "Transportation"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
    case health = "Health"
    case education = "Education"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .salary: return "dollarsign.circle"
        case .freelance: return "briefcase"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .food: return "fork.knife"
        case .transportation: return "car"
        case .shopping: return "bag"
        case .entertainment: return "film"
        case .utilities: return "bolt"
        case .health: return "heart"
        case .education: return "book"
        case .other: return "questionmark.circle"
        }
    }
    
    var color: String {
        switch self {
        case .salary: return "category1"
        case .freelance: return "category2"
        case .investment: return "category3"
        case .food: return "category4"
        case .transportation: return "category5"
        case .shopping: return "category6"
        case .entertainment: return "category7"
        case .utilities: return "category8"
        case .health: return "category9"
        case .education: return "category10"
        case .other: return "category11"
        }
    }
}
