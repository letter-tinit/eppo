//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CustomSettingNavigationLink<Destination: View>: View {
    // MARK: - PROPERTY
    let image: String
    let title: String
    let destination: Destination
    
    // MARK: - BODY
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                
                Text(title)
                    .font(.system(size: 16))
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 20)
            }
            .fontWeight(.semibold)
            .foregroundStyle(.black)
            .padding(.horizontal)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    CustomSettingNavigationLink(image: "person", title: "Tài khoản của tôi", destination: Text("Destination View"))
}
