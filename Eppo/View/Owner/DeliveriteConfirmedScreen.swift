//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import PhotosUI
import Combine

enum RefundStatus: String, CaseIterable {
    case faild = "Thất bại"
    case success = "Thành công"
}

enum DamagedStatus: String, CaseIterable {
    case undamage = "Không hư hại"
    case damage = "Có hư hại"
}

struct DeliveriteConfirmedScreen: View {
    // MARK: - ENUM
    enum ActiveAlert {
        case first, second, third
    }
    
    // MARK: - PROPERTY
    let orderId: Int
    @State var isRefund = false
    @State var isRequestSucesss = false
    @State private var errorMessage: String = ""
    @State private var additionalImagePickerItems: [PhotosPickerItem] = []
    @State private var isLoading: Bool = false
    @State private var isAlertShowing: Bool = false
    @State private var additionalImages: [UIImage] = []
    @State private var activeAlert: ActiveAlert = .first
    private let maxImages = 5
    @State private var cancellables: Set<AnyCancellable> = []
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRefundStatus: RefundStatus = .faild
    @State private var selectedDamagedStatus: DamagedStatus = .undamage
    @State private var damagedValueTextField: String = ""
    //    @State
    
    // MARK: - BODY
    
    var body: some View {
        ZStack {
            VStack {
                CustomHeaderView(title: isRefund ? "Thu hồi cây" : "Xác nhận giao hàng")
                // Additional Images Picker
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Thông tin thu hồi")
                        .font(.headline)
                        .foregroundStyle(.black)
                    
                    Picker("Trạng thái thu hồi", selection: $selectedRefundStatus) {
                        ForEach(RefundStatus.allCases, id: \.self) { refundStatus in
                            Text(refundStatus.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Trạng thái hư hại", selection: $selectedDamagedStatus) {
                        ForEach(DamagedStatus.allCases, id: \.self) { damagedStatus in
                            Text(damagedStatus.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .opacity(selectedRefundStatus == .success ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: selectedRefundStatus)
                    
                    HStack(alignment: .bottom) {
                        Text("Tiền bồi thường")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        BorderTextField {
                            HStack {
                                TextField("Số tiền", text: $damagedValueTextField)
                                    .keyboardType(.numberPad)
                                
                                Spacer()
                                
                                Text("₫")
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                    }
                    .opacity(isValueInputVisible() ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isValueInputVisible())
                }
                .padding()
                .opacity(isRefund ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isRefund)
                
                Spacer()
                
                VStack {
                    Text("Hình ảnh bổ sung").font(.headline)
                    
                    PhotosPicker(selection: $additionalImagePickerItems, matching: .images) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                    }
                    .onChange(of: additionalImagePickerItems) { _, newValue in
                        Task {
                            await handleAdditionalImagesPicker(newValue)
                        }
                    }
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(additionalImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal)
                }
                .opacity(isSelectedImageVisible() ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isSelectedImageVisible())
                
                Spacer()
                
                Button {
                    if isRefund {
                        if additionalImages.isEmpty && selectedRefundStatus == .success {
                            errorMessage = "Bạn phải đính kèm hình ảnh chứng minh"
                            activeAlert = .first
                            isAlertShowing.toggle()
                        } else {
                            errorMessage = "Bạn muốn xác nhận thông tin thu hồi không?"
                            activeAlert = .third
                            isAlertShowing.toggle()
                        }
                    } else {
                        if additionalImages.isEmpty {
                            errorMessage = "Bạn phải đính kèm hình ảnh chứng minh"
                            activeAlert = .first
                            isAlertShowing.toggle()
                        }
                    }
                } label: {
                    Text("Xác nhận")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.blue)
                        )
                        .foregroundStyle(.white)
                        .padding()
                }
            }
            .disabled(isLoading)
            .blur(radius: isLoading ? 3.0 : 0)
            
            LoadingCenterView()
                .opacity(isLoading ? 1 : 0)
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $isAlertShowing) {
            switch activeAlert {
            case .first:
//                return Alert(title: Text(errorMessage), dismissButton: .cancel({
//                    if isRequestSucesss {
//                        dismiss()
//                    }
//                }))
                return Alert(title: Text(errorMessage), dismissButton: .cancel())
            case .second:
                return Alert(title: Text("Xác nhận"), message: Text(errorMessage), primaryButton: .default(Text("Thành công"), action: {
                    // THÀNH CÔNG
                    sucessToDeliverite()
                }), secondaryButton: .destructive(Text("Thất bại"), action: {
                    // THẤT BẠI
                    failToDeliverite()
                }))
            case .third:
                return Alert(title: Text(errorMessage), primaryButton: .default(Text("Xác nhận"), action: {
                    switch selectedRefundStatus {
                    case .faild:
                        failedRefund()
                    case .success:
                        successRefund()
                    }
                }), secondaryButton: .cancel())
            }
        }
    }
    
    private func handleAdditionalImagesPicker(_ selectedItems: [PhotosPickerItem]) async {
        self.additionalImages.removeAll()
        for selectedItem in selectedItems.prefix(maxImages) {
            if let data = try? await selectedItem.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                additionalImages.append(image)
            }
        }
    }
    
    private func sucessToDeliverite() {
        self.isLoading = true
        
        APIManager.shared.confirmDeliverited(orderId: orderId, images: additionalImages)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    showAlert(activeAlert: .first, message: "Đã ghi nhận trạng thái thành công")
                    print("Đã cập nhật trạng thái thành công")
                    self.isRequestSucesss = true
                case .failure(let error):
                    showAlert(activeAlert: .first, message: "Lỗi không xác định: \(error)")
                    print("Unexpected error: \(error)")
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã cập nhật trạng thái thành công: \(response)")
            })
            .store(in: &cancellables)
    }
    
    private func failToDeliverite() {
        self.isLoading = true
        
        APIManager.shared.failDeliverited(orderId: orderId, images: additionalImages)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    showAlert(activeAlert: .first, message: "Đã ghi nhận trạng thái thành công")
                    print("Đã cập nhật trạng thái thành công")
                    self.isRequestSucesss = true
                case .failure(let error):
                    showAlert(activeAlert: .first, message: "Lỗi không xác định: \(error)")
                    print("Unexpected error: \(error)")
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã cập nhật trạng thái thành công: \(response)")
            })
            .store(in: &cancellables)
    }
    
    private func successRefund() {
        self.isLoading = true
        var depositDescription: String = ""
        
        var damagedValue: Double = 0.0
        
        switch selectedDamagedStatus {
        case .undamage:
            depositDescription = "Cây không hư hại"
        case .damage:
            depositDescription = "Cây hư hại"
            print(damagedValueTextField)
            guard let damagedValueNumber = Double(damagedValueTextField) else {
                self.isLoading = false
                showAlert(activeAlert: .first, message: "Dữ liệu nhập vào không hợp lệ")
                return
            }
            
            if damagedValueNumber <= 0.0 {
                self.isLoading = false
                showAlert(activeAlert: .first, message: "Số tiền bạn nhập phải lớn hơn 0")
            } else {
                damagedValue = damagedValueNumber
            }
        }
        
        APIManager.shared.successRefund(orderId: orderId, depositDescription: depositDescription, depositReturnOwner: damagedValue, images: additionalImages)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    showAlert(activeAlert: .first, message: "Đã ghi nhận trạng thái thành công")
                    print("Đã cập nhật trạng thái thành công")
                    self.isRequestSucesss = true
                case .failure(let error):
                    print("Unexpected error: \(error)")
                    showAlert(activeAlert: .first, message: "Lỗi không xác định: \(error)")
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã ghi nhận thành công: \(response)")
            })
            .store(in: &cancellables)
    }
    
    private func failedRefund() {
        self.isLoading = true
        
        APIManager.shared.failedRefund(orderId: orderId)
            .sink { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    showAlert(activeAlert: .first, message: "Đã ghi nhận trạng thái thành công")
                    break
                case .failure(let error):
                    showAlert(activeAlert: .first, message: "Lỗi không xác định: \(error.localizedDescription)")
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in}
            .store(in: &cancellables)
    }
    
    private func isValueInputVisible() -> Bool {
        return (selectedRefundStatus == .success && selectedDamagedStatus == .damage)
    }
    
    private func isSelectedImageVisible() -> Bool {
        if isRefund {
            if selectedRefundStatus == .success {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    private func validateInput() {
        if let value = Double(damagedValueTextField) {
            // Clamp value between 0 and 100
            if value < 0 {
                damagedValueTextField = "0"
            } else if value > 100 {
                damagedValueTextField = "100"
            }
        } else {
            // Reset to 0 if input is invalid
            damagedValueTextField = "0"
        }
    }
    
    private func showAlert(activeAlert: ActiveAlert, message: String) {
        DispatchQueue.main.async {
            self.activeAlert = activeAlert
            self.errorMessage = message
            self.isAlertShowing = true
        }
    }
}

// MARK: - PREVIEW
#Preview {
    DeliveriteConfirmedScreen(orderId: 1)
}
