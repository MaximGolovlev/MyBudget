//
//  TemplatesView.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//

import SwiftUI


struct TemplatesView: View {
    
    @ObservedObject var viewModel: BudgetViewModel
    @State private var showingAddTemplate = false
    
    var body: some View {
        List {
            Section {
                if viewModel.templates.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.on.doc")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        
                        Text("No Templates")
                            .font(.headline)
                        
                        Text("Create templates for frequent transactions to save time")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.templates) { template in
                        TemplateRow(template: template) {
                            viewModel.useTemplate(template)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTemplate)
                }
            }
            
            Section {
                Button("Add Sample Data") {
                    viewModel.addSampleData()
                }
                
                Button("Clear All Data", role: .destructive) {
                    viewModel.clearAllData()
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Templates")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddTemplate.toggle() }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingAddTemplate) {
            AddTemplateView(viewModel: viewModel)
        }
    }
}

struct TemplateRow: View {
    let template: Transaction
    let onUse: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: template.category.icon)
                .font(.title3)
                .foregroundColor(Color(template.category.color))
                .frame(width: 40, height: 40)
                .background(Color(template.category.color).opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(template.title)
                    .font(.headline)
                
                Text(template.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(template.amount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(template.type == .income ? .green : .red)
                
                Button("Use") {
                    onUse()
                }
                .buttonStyle(.plain)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
}
