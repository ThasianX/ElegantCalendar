// Kevin Li - 12:07 AM - 6/23/20

import SwiftUI

// Kudos: https://github.com/fredyshox/PageView

/**
    Container for composite pages
 */
public struct PageContainer<Content>: View where Content: View {
    let count: Int
    let content: Content

    public var body: some View {
        content
    }
}

/**
    Modified version of ViewBuilder, which does the counting of child views.
    Other than that it works the same way as the original
 */
@_functionBuilder
public struct PageViewBuilder {
    public static func buildBlock<Content>(_ c: Content) -> PageContainer<Content> {
        return PageContainer(count: 1, content: c)
    }

    public static func buildBlock<C0, C1>(
        _ c0: C0,
        _ c1: C1
    ) -> PageContainer<TupleView<(C0, C1)>>
    where
        C0 : View,
        C1 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1)
        return PageContainer(count: 2, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2
    ) -> PageContainer<TupleView<(C0, C1, C2)>>
    where
        C0 : View,
        C1 : View,
        C2 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2)
        return PageContainer(count: 3, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2, C3>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3
    ) -> PageContainer<TupleView<(C0, C1, C2, C3)>>
    where
        C0 : View,
        C1 : View,
        C2 : View,
        C3 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2, c3)
        return PageContainer(count: 4, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2, C3, C4>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4
    ) -> PageContainer<TupleView<(C0, C1, C2, C3, C4)>>
    where
        C0 : View,
        C1 : View,
        C2 : View,
        C3 : View,
        C4 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2, c3, c4)
        return PageContainer(count: 5, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5
    ) -> PageContainer<TupleView<(C0, C1, C2, C3, C4, C5)>>
    where
        C0 : View,
        C1 : View,
        C2 : View,
        C3 : View,
        C4 : View,
        C5 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2, c3, c4, c5)
        return PageContainer(count: 6, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6
    ) -> PageContainer<TupleView<(C0, C1, C2, C3, C4, C5, C6)>>
    where
        C0 : View,
        C1 : View,
        C2 : View,
        C3 : View,
        C4 : View,
        C5 : View,
        C6 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6)
        return PageContainer(count: 7, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7
    ) -> PageContainer<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7)>>
    where
        C0 : View,
        C1 : View,
        C2 : View,
        C3 : View,
        C4 : View,
        C5 : View,
        C6 : View,
        C7 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6, c7)
        return PageContainer(count: 8, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8
    ) -> PageContainer<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8)>>
    where
        C0 : View,
        C1 : View,
        C2 : View,
        C3 : View,
        C4 : View,
        C5 : View,
        C6 : View,
        C7 : View,
        C8 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6, c7, c8)
        return PageContainer(count: 9, content: compositeView)
    }

    public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(
        _ c0: C0,
        _ c1: C1,
        _ c2: C2,
        _ c3: C3,
        _ c4: C4,
        _ c5: C5,
        _ c6: C6,
        _ c7: C7,
        _ c8: C8,
        _ c9: C9
    ) -> PageContainer<TupleView<(C0, C1, C2, C3, C4, C5, C6, C7, C8, C9)>>
    where
        C0 : View,
        C1 : View,
        C2 : View,
        C3 : View,
        C4 : View,
        C5 : View,
        C6 : View,
        C7 : View,
        C8 : View,
        C9 : View
    {
        let compositeView = ViewBuilder.buildBlock(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
        return PageContainer(count: 10, content: compositeView)
    }
}
