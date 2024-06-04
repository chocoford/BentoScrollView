//
//  BentoScrollView.swift
//  Foto
//
//  Created by Dove Zachary on 2024/6/1.
//

import SwiftUI

// FIXME: Performance issue: BentoContent
@available(iOS 17.0, macOS 14.0, *)
public struct BentoScrollView<Header: View>: View {
    var header: (_ height: CGFloat) -> Header
    var content: [BentoContent]
    var spacing: CGFloat
    
    public init(
        spacing: CGFloat = .zero,
        @BentoContentBuilder content: () -> [BentoContent],
        @ViewBuilder header: @escaping (_ height: CGFloat) -> Header
    ) {
        self.spacing = spacing
        self.content = content()
        self.header = header
    }
    
    private var config: Config = Config()
    
    @State private var headerHeight: CGFloat?
    @State private var headerTop: CGFloat = .zero
    
    var renderHederHeight: CGFloat? {
        guard let headerHeight else { return nil }
        return max(headerHeight + headerTop, self.config.headerMinHeight ?? headerHeight)
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: spacing) {
                Color.clear
                    .frame(
                        minHeight: self.config.headerMinHeight ?? self.headerHeight,
                        idealHeight: self.headerHeight,
                        maxHeight: self.headerHeight
                    )
                    .scrollTop(top: $headerTop)
                
                LazyVStack(spacing: spacing) {
                    Section {
                        ForEach(content) { content in
                            BentoScrollSectionView(
                                headerHeight: renderHederHeight ?? .zero,
                                maskShape: config.bentoShape,
                                spacing: spacing,
                                content: content
                            )
                        }
                        .padding(config.bentoItemInsets)
                    }
                }
            }
            .padding(config.scrollContentInsets)
        }
        .overlay(alignment: .top) {
            ZStack {
                header(renderHederHeight ?? .zero)
                    .bindSize(
                        Binding(get: {
                            .zero
                        }, set: { val in
                            headerHeight = val.height
                        })
                    )
            }
            .frame(
                height: renderHederHeight,
                alignment: (renderHederHeight ?? .zero) <= (headerHeight ?? .zero) + 1e-4 ? .top : .center
            )
            .padding(.bottom, spacing)
            .clipped()
        }
    }
}


extension BentoScrollView {
    public class Config {
        var bentoShape: AnyShape = AnyShape(Rectangle())
        var headerMinHeight: CGFloat?
        var headerHeightBinding: Binding<CGFloat>?
        var scrollContentInsets: EdgeInsets = .zero
        var bentoItemInsets: EdgeInsets = .zero
    }
    
    public func bentoShape(_ style: some Shape) -> BentoScrollView {
        self.config.bentoShape = AnyShape(style)
        return self
    }
    
    public func headerMinHeight(_ height: CGFloat?) -> BentoScrollView {
        self.config.headerMinHeight = height
        return self
    }
    
    public func scrollContentInsets(_ insets: EdgeInsets) -> BentoScrollView {
        self.config.scrollContentInsets = insets
        return self
    }
    
    public func bentoItemInsets(_ insets: EdgeInsets) -> BentoScrollView {
        self.config.bentoItemInsets = insets
        return self
    }
    
}

extension View {
    @MainActor @ViewBuilder
    /// Specify the header of the bento section.
    ///
    /// You should use this at the end of the view.
    ///
    /// ```swift
    ///     VStack(alignment: .leading) {
    ///         ...
    ///     }
    ///     .padding()  // some view modifiers.
    ///     .background {
    ///         RoundedRectangle(cornerRadius: 12)
    ///     }
    ///     .bentoSectionHeader {
    ///         Text("Header")
    ///     } // <-- use it at the end of view.
    /// ```
    public func bentoSectionHeader<Header: View>(@ViewBuilder header: @escaping () -> Header) -> BentoScrollViewSection {
        BentoScrollViewSection {
            self
        }
        .bentoSectionHeader(header: header)
    }
    
    @MainActor @ViewBuilder
    public func bentoSectionBackground<BG: View>(@ViewBuilder background: @escaping () -> BG) -> BentoScrollViewSection {
        BentoScrollViewSection {
            self
        }
        .bentoSectionBackground(background: background)
    }
    
    @MainActor @ViewBuilder
    public func bentoSetionHeaderDisplayMode(mode: HeaderDisplayMode) -> BentoScrollViewSection {
        BentoScrollViewSection {
            self
        }
        .bentoSetionHeaderDisplayMode(mode: mode)
    }
}

#if DEBUG
#Preview {
    BentoScrollPreviewView()
}
#endif
