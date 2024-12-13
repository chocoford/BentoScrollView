//
//  BentoContentBuilder.swift
//  Foto
//
//  Created by Dove Zachary on 2024/6/3.
//

import SwiftUI

@resultBuilder
public struct BentoContentBuilder {
    public static func buildBlock(_ components: BentoScrollViewSection...) -> [BentoContent] {
        components.map {
            let components = $0.getComponents()
            return BentoContent(
                content: components.content,
                header: components.config.header,
                background: components.config.background,
                headerDisplayMode: components.config.headerDisplayMode
            )
        }
    }
    
    public static func buildBlock<Content: View>(_ components: Content...) -> [BentoContent] {
        components.map {
            return BentoContent(
                content: AnyView($0),
                header: nil
            )
        }
    }
    
    public static func buildExpression<Content: View>(_ expression: Content) -> BentoScrollViewSection {
        return BentoScrollViewSection {
            expression
        }
    }
    
    public static func buildExpression(_ expression: BentoScrollViewSection) -> BentoScrollViewSection {
        return expression
    }
}
