//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct GenderSelector: View {
    @Binding var selectedGender: String

    var body: some View {
        HStack(spacing: 40) {
            ForEach(["Nam", "Nữ"], id: \.self) { gender in
                HStack {
                    Circle()
                        .strokeBorder(selectedGender == gender ? Color.blue : Color.gray, lineWidth: 2)
                        .background(Circle().foregroundColor(selectedGender == gender ? Color.blue : Color.clear))
                        .frame(width: 20, height: 20)
                    
                    Text(gender)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .semibold))
                }
                .onTapGesture {
                    selectedGender = gender
                }
            }
            
            Spacer()
        }
    }
}

struct RoleSelector: View {
    @Binding var selectedRole: String

    var body: some View {
        HStack(spacing: 40) {
            ForEach(["Người bán", "Người mua"], id: \.self) { role in
                HStack {
                    Circle()
                        .strokeBorder(selectedRole == role ? Color.blue : Color.gray, lineWidth: 2)
                        .background(Circle().foregroundColor(selectedRole == role ? Color.blue : Color.clear))
                        .frame(width: 20, height: 20)
                    
                    Text(role)
                        .foregroundColor(.black)
                        .font(.system(size: 16, weight: .semibold))
                }
                .onTapGesture {
                    selectedRole = role
                }
            }
            
            Spacer()
        }
    }
}



// MARK: - PREVIEW
#Preview {
    GenderSelector(selectedGender: .constant("Nam"))
}
