import SwiftUI

struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(DismissGestureView())
    }
}

private struct DismissGestureView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let recognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tap))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    class Coordinator {
        @objc func tap() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension View {
    /// Dismisses the keyboard when tapping outside of a text input view.
    func dismissKeyboardOnTap() -> some View {
        modifier(KeyboardDismissModifier())
    }
}
