//
//  BentoScrollViewSection.swift
//  Foto
//
//  Created by Dove Zachary on 2024/6/3.
//

import SwiftUI

public struct BentoContent: Identifiable {
    public var id = UUID()
    public var content: AnyView
    public var header: AnyView?
    public var background: AnyView?
    public var headerDisplayMode: HeaderDisplayMode = .autoHide
}

public struct BentoScrollViewSection: View {
    var content: AnyView
    
    internal var config = Config()
    
    init<Content: View>(
        @ViewBuilder content: () -> Content
    ) {
        self.content = AnyView(content())
    }
    
    public var body: some View {
        EmptyView()
    }
    
    func getComponents() -> Components {
        return Components(
            content: content,
            config: config
        )
    }
}

public enum HeaderDisplayMode {
    case permanent
    case autoHide
}

extension BentoScrollViewSection {
    public class Config {
        var header: AnyView?
        var background: AnyView?
        var headerDisplayMode: HeaderDisplayMode = .autoHide
    }
    
    struct Components {
        var content: AnyView
        var config: Config
    }
    
    @MainActor
    public func bentoSectionHeader<Header: View>(@ViewBuilder header: () -> Header) -> Self {
        self.config.header = AnyView(header())
        return self
    }
    
    @MainActor
    public func bentoSectionBackground<BG: View>(@ViewBuilder background: () -> BG) -> Self {
        self.config.background = AnyView(background())
        return self
    }
    
    @MainActor
    public func bentoSetionHeaderDisplayMode(mode: HeaderDisplayMode) -> Self {
        self.config.headerDisplayMode = mode
        return self
    }
}

@available(iOS 17.0, macOS 14.0, *)
internal struct BentoScrollSectionView: View {
    var headerHeight: CGFloat
    var maskShape: AnyShape
    var spacing: CGFloat
    var content: BentoContent
    
    @State private var scrollTop: CGFloat = .zero
    @State private var size: CGSize = .zero
    @State private var sectionHeaderSize: CGSize = .zero
    
    var headerOffsetY: CGFloat {
        -1 * (scrollTop - headerHeight - spacing)
    }
    
    private var canShowHeader: Bool {
        headerOffsetY > sectionHeaderSize.height
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if let header = content.header,
               content.headerDisplayMode == .permanent {
                BentoScrollSectionContentView {
                    header
                }
                .bindSize($sectionHeaderSize)
                .offset(
                    y: max(
                        headerOffsetY,
                        0
                    )
                )
            }
            
            ZStack(alignment: .top) {
                if let header = content.header,
                   content.headerDisplayMode == .autoHide {
                    BentoScrollSectionContentView {
                        header
                    }
                    .bindSize($sectionHeaderSize)
                    .offset(
                        y: min(
                            headerOffsetY,
                            size.height - sectionHeaderSize.height
                        )
                    )
                    .opacity(max(0, (headerOffsetY - sectionHeaderSize.height) / 10.0))
                }
                
                BentoScrollSectionContentView {
                    content.content
                }
                .mask(alignment: .bottom) {
                    if content.headerDisplayMode == .autoHide {
                        let displayHeight: CGFloat = size.height - headerOffsetY - sectionHeaderSize.height
                        let containerHeight: CGFloat = size.height - headerOffsetY
                        let opacity: Double = max(0, (headerOffsetY - 0.5 * sectionHeaderSize.height) / 10.0)
                        maskShape
                            .fill(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color.white, location: 0.0),
                                        Gradient.Stop(
                                            color: Color.white.opacity(1.0),
                                            location: max(0, min(1, displayHeight / containerHeight) - 1.01 * 1e-6)
                                        ),
                                        Gradient.Stop(
                                            color: Color.white.opacity(1 - opacity),
                                            location: max(1e-5, min(1, displayHeight / containerHeight) - 1e-6)
                                        ),
                                        Gradient.Stop(
                                            color: Color.white.opacity(1 - opacity),
                                            location: 1
                                        )
                                    ],
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                            )
                            .opacity(1-1e-6)
                            .frame(height: max(0, containerHeight))
                    } else {
                        maskShape
                            .opacity(1-1e-6)
                            .frame(height: max(0, size.height - headerOffsetY - sectionHeaderSize.height))
                    }
                }
            }
        }
        .bindSize($size)
        .scrollTop(top: $scrollTop)
        .background {
            if let background = content.background {
                background
            }
        }
        .mask(alignment: .bottom) {
            maskShape
                .opacity(1-1e-6)
                .frame(height: max(sectionHeaderSize.height, size.height - headerOffsetY))
        }
        .opacity(1.0 - max(0, (sectionHeaderSize.height + headerOffsetY - size.height) / sectionHeaderSize.height))
    }
}

struct BentoScrollSectionContentView: View {
    var content: AnyView
    
    init<Content: View>(@ViewBuilder content: () -> Content) {
        self.content = AnyView(content())
    }
    
    var body: some View {
//        let _ = Self._printChanges()
        content
    }
}


#if DEBUG
#Preview {
    BentoScrollPreviewView()
}
#endif
