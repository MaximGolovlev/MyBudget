//
//  TransactionsListView.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//

import SwiftUI

struct TransactionsListView: View {
    
    @ObservedObject var viewModel: BudgetViewModel
    @Binding var showingAddTransaction: Bool
    @State private var showingFilters = false
    @State private var selectedType: TransactionType? = nil
    @State private var selectedCategory: Category? = nil
    
    var filteredTransactions: [Transaction] {
        var filtered = viewModel.transactions
        
        if let type = selectedType {
            filtered = filtered.filter { $0.type == type }
        }
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        return filtered
    }
    
    var body: some View {
        List {
            ForEach(filteredTransactions) { transaction in
                TransactionRow(transaction: transaction)
            }
            .onDelete(perform: viewModel.deleteTransaction)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Filter") {
                    showingFilters.toggle()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddTransaction.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .overlay {
            if filteredTransactions.isEmpty {
                ContentUnavailableView(
                    "No Transactions",
                    systemImage: "list.bullet",
                    description: Text(viewModel.transactions.isEmpty ? 
                        "Add your first transaction" : 
                        "No transactions match your filters")
                )
            }
        }
        .sheet(isPresented: $showingFilters) {
            FilterView(
                selectedType: $selectedType,
                selectedCategory: $selectedCategory
            )
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.visible)
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            Image(systemName: transaction.category.icon)
                .font(.title3)
                .foregroundColor(Color(transaction.category.color))
                .frame(width: 40, height: 40)
                .background(Color(transaction.category.color).opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                
                HStack {
                    Text(transaction.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(transaction.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(transaction.amount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(transaction.type == .income ? .green : .red)
                
                HStack(spacing: 4) {
                    Text(transaction.type.symbol)
                        .font(.caption)
                    Text(transaction.type.rawValue)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct FilterView: View {
    
    @Binding var selectedType: TransactionType?
    @Binding var selectedCategory: Category?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Filters")
                .font(.headline)
                .padding(.top)
                .padding(.bottom)
            
            // Type Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Transaction Type")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        FilterButton(
                            title: type.rawValue,
                            isSelected: selectedType == type,
                            action: {
                                selectedType = selectedType == type ? nil : type
                            }
                        )
                    }
                }
            }
            .padding(.bottom)
            
            // Category Filter
            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        FilterButton(
                            title: "All",
                            isSelected: selectedCategory == nil,
                            action: { selectedCategory = nil }
                        )
                        
                        ForEach(Category.allCases, id: \.self) { category in
                            FilterButton(
                                title: category.rawValue,
                                isSelected: selectedCategory == category,
                                action: {
                                    selectedCategory = selectedCategory == category ? nil : category
                                }
                            )
                        }
                    }
                }
            }
            
            Spacer()
            
            // Clear Filters Button
            Button("Clear All Filters") {
                selectedType = nil
                selectedCategory = nil
                dismiss()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }
}
