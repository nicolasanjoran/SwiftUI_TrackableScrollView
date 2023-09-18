# SwiftUI_ScrollViewWithOffset

A SwiftUI ScrollView with a binding for the scroll offset value.

> [!IMPORTANT]
> This has only be tested on iOS.

## Example:

```swift
struct ContentView: View {
    @State var offset = CGPoint() // Will be updated while scrolling
    
    var body: some View {
        VStack {
            Text("Offset: \(Int(offset.y))")
            ScrollViewWithOffset(offset: $offset) {
                LazyVStack {
                    ForEach(Array(1...200).map { "Item \($0)" }, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
    }
}
```
