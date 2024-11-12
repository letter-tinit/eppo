//
//  AddressOrderView.swift
//  Eppo
//
//  Created by Letter on 11/11/2024.
//

import SwiftUI

struct AddressOrderView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.red)
                .fontWeight(.bold)
            VStack(alignment: .leading) {
                HStack {
                    Text("Nguyễn Trung Tín")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                    
                    Text("0358887710")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundStyle(Color(uiColor: UIColor.lightGray))
                }
                Text("Quận XX, Thành Phố")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    AddressOrderView()
}
