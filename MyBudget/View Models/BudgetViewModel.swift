//
//  BudgetViewModel.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//


import Foundation
import Combine
import SwiftUI

class BudgetViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var templates: [Transaction] = []
    @Published var totalIncome: Double = 0
    @Published var totalExpense: Double = 0
    @Published var balance: Double = 0
    
    private let transactionsKey = "transactions"
    private let templatesKey = "templates"
    
    init() {
        loadTransactions()
        loadTemplates()
        calculateTotals()
    }
    
    // MARK: - Save/Load Data
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
    
    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
    
    private func saveTemplates() {
        if let encoded = try? JSONEncoder().encode(templates) {
            UserDefaults.standard.set(encoded, forKey: templatesKey)
        }
    }
    
    private func loadTemplates() {
        if let data = UserDefaults.standard.data(forKey: templatesKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            templates = decoded
        }
    }
    
    // MARK: - Transactions Management
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        transactions.sort { $0.date > $1.date }
        saveTransactions()
        calculateTotals()
    }
    
    func addTemplate(_ template: Transaction) {
        let templateTransaction = Transaction(
            id: UUID(),
            title: template.title,
            amount: template.amount,
            type: template.type,
            category: template.category,
            date: Date(),
            isTemplate: true
        )
        templates.append(templateTransaction)
        templates.sort { $0.title < $1.title }
        saveTemplates()
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
        saveTransactions()
        calculateTotals()
    }
    
    func deleteTemplate(at offsets: IndexSet) {
        templates.remove(atOffsets: offsets)
        saveTemplates()
    }
    
    func useTemplate(_ template: Transaction) {
        let newTransaction = Transaction(
            title: template.title,
            amount: template.amount,
            type: template.type,
            category: template.category
        )
        addTransaction(newTransaction)
    }
    
    // MARK: - Calculations
    private func calculateTotals() {
        totalIncome = transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        
        totalExpense = transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
        
        balance = totalIncome - totalExpense
    }
    
    func categoryBreakdown(for type: TransactionType) -> [(category: Category, amount: Double, percentage: Double)] {
        let filteredTransactions = transactions.filter { $0.type == type }
        let total = type == .income ? totalIncome : totalExpense
        
        var breakdown: [Category: Double] = [:]
        
        for transaction in filteredTransactions {
            breakdown[transaction.category, default: 0] += transaction.amount
        }
        
        return breakdown.map { category, amount in
            let percentage = total > 0 ? (amount / total) * 100 : 0
            return (category, amount, percentage)
        }
        .sorted { $0.amount > $1.amount }
    }
    
    // MARK: - Sample Data
    func addSampleData() {
        let sampleTransactions = [
            Transaction(title: "Salary", amount: 2500, type: .income, category: .salary),
            Transaction(title: "Groceries", amount: 85.50, type: .expense, category: .food),
            Transaction(title: "Netflix", amount: 15.99, type: .expense, category: .entertainment),
            Transaction(title: "Gas", amount: 45.00, type: .expense, category: .transportation),
            Transaction(title: "Freelance Work", amount: 500, type: .income, category: .freelance)
        ]
        
        for transaction in sampleTransactions {
            addTransaction(transaction)
        }
        
        let sampleTemplates = [
            Transaction(title: "Weekly Groceries", amount: 100, type: .expense, category: .food),
            Transaction(title: "Monthly Rent", amount: 1200, type: .expense, category: .utilities)
        ]
        
        for template in sampleTemplates {
            addTemplate(template)
        }
    }
    
    func clearAllData() {
        transactions.removeAll()
        templates.removeAll()
        saveTransactions()
        saveTemplates()
        calculateTotals()
    }
}
