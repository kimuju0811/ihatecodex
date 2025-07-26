import SwiftUI

struct LoadingView: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(geo.size.width, geo.size.height) * 0.5)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2.0)
                    .padding(.top)
                Spacer().frame(height: geo.size.height * 0.25)
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
