//
//  PieChartView.swift
//  MyBudget
//
//  Created by Maxim Golovlev on 08.01.2026.
//


import SwiftUI

struct PieChartView: View {
    let data: [Double]
    let colors: [Color]
    let names: [String]
    let percentages: [Double]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<data.count, id: \.self) { index in
                    PieSlice(
                        startAngle: startAngle(for: index),
                        endAngle: endAngle(for: index),
                        color: colors[index]
                    )
                }
                
                // Center circle
                Circle()
                    .fill(Color(.systemBackground))
                    .frame(width: geometry.size.width * 0.4, height: geometry.size.height * 0.4)
                
                VStack {
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("$\(data.reduce(0, +), specifier: "%.2f")")
                        .font(.headline)
                }
            }
        }
    }
    
    private func startAngle(for index: Int) -> Angle {
        let total = data.reduce(0, +)
        guard total > 0 else { return .degrees(0) }
        
        var startAngle: Double = -90
        for i in 0..<index {
            startAngle += 360 * (data[i] / total)
        }
        return .degrees(startAngle)
    }
    
    private func endAngle(for index: Int) -> Angle {
        let total = data.reduce(0, +)
        guard total > 0 else { return .degrees(0) }
        
        var endAngle: Double = -90
        for i in 0...index {
            endAngle += 360 * (data[i] / total)
        }
        return .degrees(endAngle)
    }
}

struct PieSlice: View {
    let startAngle: Angle
    let endAngle: Angle
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                let radius = min(geometry.size.width, geometry.size.height) / 2
                
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    clockwise: false
                )
            }
            .fill(color)
        }
    }
}