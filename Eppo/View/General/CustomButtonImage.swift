//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct CustomButtonImage<Destination: View>: View {
    // MARK: - PROPERTY
    let imageName: String
    let title: String
    let destination: Destination

    // MARK: - BODY

    var body: some View {
        NavigationLink {
            destination
        } label: {
            VStack(spacing: 10) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 26)
                
                Text(title)
                    .font(.system(size: 13))
            }
        }
        .foregroundStyle(.black)
    }
}

// MARK: - PREVIEW
//#Preview {
//    CustomButtonImage(imageName: "person", title: "Person") {
//        //action
//    }
//}
