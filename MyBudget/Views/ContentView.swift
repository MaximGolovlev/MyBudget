//
//  ContentView.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//


import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = BudgetViewModel()
    @State private var showingAddTransaction = false
    @State private var showingTemplates = false
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                DashboardView(showingAddTransaction: $showingAddTransaction, viewModel: viewModel)
            }
            .tabItem {
                Label("Dashboard", systemImage: "chart.pie")
            }
            .tag(0)
            
            NavigationView {
                TransactionsListView(viewModel: viewModel, showingAddTransaction: $showingAddTransaction)
            }
            .tabItem {
                Label("Transactions", systemImage: "list.bullet")
            }
            .tag(1)
            
            NavigationView {
                TemplatesView(viewModel: viewModel)
            }
            .tabItem {
                Label("Templates", systemImage: "doc.on.doc")
            }
            .tag(2)
        }
        .accentColor(.blue)
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView(viewModel: viewModel)
        }
    }
}

struct DashboardView: View {
    
    @Binding var showingAddTransaction: Bool
    @ObservedObject var viewModel: BudgetViewModel
    @State private var selectedType: TransactionType = .expense
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with app description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Track your income and expenses with simple manual input. Create templates for frequent transactions and visualize spending with category charts.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Balance Cards
                VStack(spacing: 16) {
                    BalanceCard(
                        title: "Current Balance",
                        amount: viewModel.balance,
                        color: viewModel.balance >= 0 ? .green : .red
                    )
                    
                    HStack(spacing: 16) {
                        BalanceCard(
                            title: "Total Income",
                            amount: viewModel.totalIncome,
                            color: .green
                        )
                        
                        BalanceCard(
                            title: "Total Expenses",
                            amount: viewModel.totalExpense,
                            color: .red
                        )
                    }
                }
                .padding(.horizontal)
                
                // Chart Type Selector
                Picker("Chart Type", selection: $selectedType) {
                    Text("Expenses").tag(TransactionType.expense)
                    Text("Income").tag(TransactionType.income)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Pie Chart
                if !viewModel.categoryBreakdown(for: selectedType).isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(selectedType.rawValue) by Category")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        PieChartView(
                            data: viewModel.categoryBreakdown(for: selectedType).map { $0.amount },
                            colors: viewModel.categoryBreakdown(for: selectedType).map { Color($0.category.color) },
                            names: viewModel.categoryBreakdown(for: selectedType).map { $0.category.rawValue },
                            percentages: viewModel.categoryBreakdown(for: selectedType).map { $0.percentage }
                        )
                        .frame(height: 250)
                        .padding(.horizontal)
                        
                        // Legend
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(viewModel.categoryBreakdown(for: selectedType), id: \.category) { item in
                                HStack {
                                    Circle()
                                        .fill(Color(item.category.color))
                                        .frame(width: 12, height: 12)
                                    
                                    Text(item.category.rawValue)
                                        .font(.caption)
                                    
                                    Spacer()
                                    
                                    Text("\(item.amount, specifier: "%.2f")")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    Text("(\(item.percentage, specifier: "%.1f")%)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.pie")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        
                        Text("No \(selectedType.rawValue.lowercased()) data")
                            .font(.headline)
                        
                        Text("Add transactions to see the category breakdown")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
                
                Spacer()
            }
        }
        .navigationTitle("MyBudget")
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddTransaction.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .background(Color(.systemBackground))
    }
}

struct BalanceCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("$\(amount, specifier: "%.2f")")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
