import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.5)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding(.top)
                Spacer().frame(height: geo.size.height * 0.2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LoadingView()
}
