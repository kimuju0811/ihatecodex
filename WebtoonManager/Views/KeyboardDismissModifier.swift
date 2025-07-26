import SwiftUI

struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white.opacity(0.001).ignoresSafeArea())
            .background(DismissGestureView())
    }
}

private struct DismissGestureView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 1, alpha: 0.001)
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false

        let recognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.tap))
        recognizer.cancelsTouchesInView = false
        recognizer.delaysTouchesBegan = false
        recognizer.delaysTouchesEnded = false
        recognizer.delegate = context.coordinator
        view.addGestureRecognizer(recognizer)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let superview = uiView.superview, uiView.constraints.isEmpty else { return }
        NSLayoutConstraint.activate([
            uiView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            uiView.topAnchor.constraint(equalTo: superview.topAnchor),
            uiView.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @objc func tap() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            var view = touch.view
            while let current = view {
                if current is UITextField || current is UITextView { return false }
                view = current.superview
            }
            return true
        }

    }
}

extension View {
    /// Dismisses the keyboard when tapping outside of a text input view.
    func dismissKeyboardOnTap() -> some View {
        modifier(KeyboardDismissModifier())
    }
}
