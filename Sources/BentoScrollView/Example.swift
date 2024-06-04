//
//  File.swift
//  
//
//  Created by Dove Zachary on 2024/6/3.
//

#if DEBUG
import SwiftUI

struct BentoScrollPreviewView: View {
    @State private var headerHeight: CGFloat = .zero

    var body: some View {
        BentoScrollView(spacing: 10) {
            VStack(alignment: .leading) {
                Text("31 - Excellent")
                Capsule().fill(Color.accentColor).frame(height: 3)
                Text("Current AQI (CN) is 31")
            }
            .padding()
            .bentoSectionHeader {
                HStack {
                    Image(systemName: "aqi.low")
                    Text("AIR QUALITY")
                    Spacer()
                }
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            }
            .bentoSectionBackground {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
            }
            
            VStack(alignment: .leading) {
                Text("Rainy conditions from 04:00-07:00, with windy conditions expected at 10:00.")
                Divider()
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(0...10, id: \.self) { i in
                            VStack(spacing: 10) {
                                Text(i == 0 ? "Now" : i.formatted(.number.precision(.integerLength(2))))
                                Image(systemName: "cloud")
                                    .symbolVariant(.fill)
                                    .font(.title2)
                                Text("25°")
                            }
                        }
                    }
                }
            }
            .padding()
            .bentoSectionBackground {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
            }
            .bentoSectionHeader {
                HStack {
                    Image(systemName: "clock")
                    Text("Hourly forecast".uppercased())
                    Spacer()
                }
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            }
            
            VStack {
                Divider()
                
                ForEach(0...10, id: \.self) { _ in
                    Capsule()
                        .fill(.pink.gradient)
                        .frame(height: 50)
                }
            }
            .padding()
            .bentoSectionBackground {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
            }
            .bentoSectionHeader {
                HStack {
                    Image(systemName: "calendar")
                    Text("10-day forecast".uppercased())
                    Spacer()
                }
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
            }
            .bentoSetionHeaderDisplayMode(mode: .permanent)
            
        } header: { headerHeight in
            BentoScrollHeaderView(
                headerHeight: headerHeight
            )
        }
        .bentoShape(RoundedRectangle(cornerRadius: 12))
        .bentoItemInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .headerMinHeight(80)
        .background {
            Rectangle()
                .fill(
                    Color.blue.gradient
                )
                .ignoresSafeArea()
        }
        
    }
}

struct BentoScrollHeaderView: View {
    var headerHeight: CGFloat
    
    @State private var headerOffsetY: CGFloat = .zero
    
    var body: some View {
        VStack {
            Text(headerHeight <= 81 ?  "Shenzhen" : "My Location").font(.title)
            Text(headerHeight <= 81 ? "25° | Cloudy" : "Shenzhen, China")
            Text(" 25°").font(.system(size: 96))
                .opacity(headerHeight < 140 ? 0 : 1)
            HStack {
                Text("H:32° L:25°")
                    .font(.title2)
            }
            .opacity(headerHeight < 240 ? 0 : 1)
        }
        .animation(.default, value: headerHeight)
        .padding(.top, 10)
        .padding(.bottom, 60)
        .onChange(of: headerHeight) { _, newValue in
            headerOffsetY = ((newValue - 80) / 60) * 10
        }
        .offset(y: headerOffsetY)
    }
}

#Preview {
    BentoScrollPreviewView()
}

#endif
