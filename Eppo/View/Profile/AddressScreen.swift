//
//  AddressScreen.swift
//  Eppo
//
//  Created by Letter on 12/11/2024.
//

import SwiftUI

struct AddressScreen: View {
    @Bindable var viewModel:ProfileViewModel
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title: "Địa chỉ của Tôi")
            
            List {
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
                Text("Thông Tin Địa Chỉ")
            }
            .font(.headline)
            .fontWeight(.medium)
            .fontDesign(.rounded)
            
            Button {
                viewModel.isPopup = true
            } label: {
                Text("Thêm địa chỉ")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.green)
                    .foregroundStyle(.white)
            }
        }
        .alert(
            Text(viewModel.message ?? "Nhắc nhở"),
            isPresented: $viewModel.isShowingAlert
        ) {
            Button("Đóng") {}
        }
        .sheet(isPresented: $viewModel.isPopup, content: {
            VStack {
                BorderTextField(content: {
                    TextField("Địa chỉ", text: $viewModel.addressTextField)
                })
                .frame(height: 50)
                .padding()
                .padding(.top)
                
                Button {
                    viewModel.createAddress()
                } label: {
                    Text("Tạo")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .foregroundStyle(.white)
                        .padding(.top)
                        .padding()
                }
                
                Spacer()
            }
            .presentationDetents([.medium, .large])
        })
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    AddressScreen(viewModel: ProfileViewModel())
}
