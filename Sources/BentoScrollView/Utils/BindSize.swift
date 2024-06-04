//
//  BindSize.swift
//  
//
//  Created by Dove Zachary on 2024/6/3.
//

import SwiftUI

extension View {
    @MainActor @ViewBuilder
    internal func bindSize(_ size: Binding<CGSize>) -> some View {
        background {
            GeometryReader {
                Color.clear
                    .onChange(of: $0.size, initial: true) { oldValue, newValue in
                        size.wrappedValue = newValue
                    }
            }
        }
    }
}
