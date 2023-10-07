import SwiftUI

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

enum ScrollOffsetNamespace {
    static let namespace = "ScrollViewWithTrackableOffsetNamespace"
}

struct ScrollViewOffsetTracker: View {

    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geo.frame(in: .named(ScrollOffsetNamespace.namespace)).origin
                )
        }
        .frame(height: 0)
    }
}

private extension ScrollView {
    func withOffsetTracking(
        action: @escaping (_ offset: CGPoint) -> Void
    ) -> some View {
        self.coordinateSpace(name: ScrollOffsetNamespace.namespace)
            .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: action)
    }
}

public struct ScrollViewWithOffset<Content: View>: View {
    
    var offsetBinding : Binding<CGPoint>

    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offset: Binding<CGPoint>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offsetBinding = offset
        self.content = content
    }

    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: () -> Content

    public typealias ScrollAction = (_ offset: CGPoint) -> Void

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ZStack(alignment: .top) {
                ScrollViewOffsetTracker()
                content()
            }
        }.withOffsetTracking(action: onScroll)
    }
    
    func onScroll(offset: CGPoint) {
        if offset.x <= 0.0 {
            self.offsetBinding.wrappedValue.x = offset.x
        } else {
            self.offsetBinding.wrappedValue.x = 0
        }
        
        if offset.y <= 0.0 {
            self.offsetBinding.wrappedValue.y = offset.y
        } else {
            self.offsetBinding.wrappedValue.y = 0
        }
    }
}
