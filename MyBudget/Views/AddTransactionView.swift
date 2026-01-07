//
//  AddTransactionView.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//

import SwiftUI


struct AddTransactionView: View {
    
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category = .food
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section("Transaction Details") {
                    TextField("Title", text: $title)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section {
                    Button("Save as Template") {
                        saveAsTemplate()
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    
                    Button("Add Transaction") {
                        saveTransaction()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(title.isEmpty || amount.isEmpty || Double(amount) == nil)
                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let transaction = Transaction(
            title: title,
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            date: date
        )
        
        viewModel.addTransaction(transaction)
    }
    
    private func saveAsTemplate() {
        guard let amountValue = Double(amount) else { return }
        
        let template = Transaction(
            title: title,
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            isTemplate: true
        )
        
        viewModel.addTemplate(template)
    }
}

struct AddTemplateView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: Category = .food
    
    var body: some View {
        NavigationView {
            Form {
                Section("Template Details") {
                    TextField("Template Name", text: $title)
                    
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Type", selection: $selectedType) {
                        ForEach(TransactionType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                }
                
                Section {
                    Button("Save Template") {
                        saveTemplate()
                        dismiss()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(title.isEmpty || amount.isEmpty || Double(amount) == nil)
                }
            }
            .navigationTitle("New Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTemplate() {
        guard let amountValue = Double(amount) else { return }
        
        let template = Transaction(
            title: title,
            amount: amountValue,
            type: selectedType,
            category: selectedCategory,
            isTemplate: true
        )
        
        viewModel.addTemplate(template)
    }
}
