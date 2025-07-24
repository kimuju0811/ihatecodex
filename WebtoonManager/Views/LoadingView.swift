import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    LoadingView()
}
