//
//  ScrollTop.swift
//
//
//  Created by Dove Zachary on 2024/6/3.
//

import SwiftUI

struct ScrollTopDetector: ViewModifier {
    @Binding var top: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { proxy in
                    if let distanceFromTop = proxy.bounds(of: .scrollView)?.minY {
                        Color.clear
                            .onChange(of: distanceFromTop, initial: true) { oldValue, newValue in
                                self.top = distanceFromTop * -1
                            }
                    }
                }
            )
    }
}


extension View {
    @MainActor @ViewBuilder
    public func scrollTop(top: Binding<CGFloat>) -> some View {
        modifier(ScrollTopDetector(top: top))
    }
}
