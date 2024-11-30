//
//  AddressScreen.swift
//  Eppo
//
//  Created by Letter on 12/11/2024.
//

import SwiftUI

struct AddressScreen: View {
    @State var viewModel: AddressViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CustomHeaderView(title: "Địa chỉ của Tôi")
            
            if viewModel.isLoading {
                CenterView {
                    ProgressView("Đang tải")
                }
            } else if !viewModel.addresses.isEmpty {
                List {
                    ForEach(viewModel.addresses) { address in
                        Text(address.description)
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            let addressId = viewModel.addresses[index].id
                            viewModel.deleteAddress(by: addressId)
                        }
                    }
                }
                .font(.headline)
                .fontWeight(.medium)
                .fontDesign(.rounded)
            } else {
                CenterView {
                    Text("Bạn chưa có địa chỉ nào")
                }
            }
            
            Button {
                viewModel.isPopup = true
            } label: {
                Text("Thêm địa chỉ")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
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
                    viewModel.isPopup = false
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
            .presentationDetents([.medium])
        })
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.container, edges: .top)
        .onAppear {
            if viewModel.addresses.isEmpty {
                viewModel.getAddress()
            }
        }
    }
}

#Preview {
    AddressScreen(viewModel: AddressViewModel())
}
