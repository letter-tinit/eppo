//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI
import PhotosUI
import Combine

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
    
    // MARK: - BODY
    
    var body: some View {
        VStack {
            CustomHeaderView(title: "Xác nhận giao hàng")
            // Additional Images Picker
            
            Spacer()
            
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
            
            Spacer()
            
            Button {
                if additionalImages.isEmpty {
                    errorMessage = "Bạn phải đính kèm hình ảnh chứng minh"
                    activeAlert = .first
                    isAlertShowing.toggle()
                } else if isRefund {
                    errorMessage = "Bạn muốn xác nhận đơn hàng đã thu hồi không?"
                    activeAlert = .third
                    isAlertShowing.toggle()
                } else {
                    errorMessage = "Bạn muốn xác nhận đơn hàng giao thành công hay thất bại?"
                    activeAlert = .second
                    isAlertShowing.toggle()
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
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden()
        .alert(isPresented: $isAlertShowing) {
            switch activeAlert {
            case .first:
                return Alert(title: Text(errorMessage), dismissButton: .cancel({
                    if isRequestSucesss {
                        dismiss()
                    }
                }))
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
                    finishRefund()
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
        APIManager.shared.confirmDeliverited(orderId: orderId, images: additionalImages)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.errorMessage = "Đã cập nhật trạng thái thành công, Đơn hàng sẽ phải chờ xét duyệt"
                    self.isAlertShowing = true
                    self.activeAlert = .first
                    print("Đã cập nhật trạng thái thành công")
                    self.isRequestSucesss = true
                case .failure(let error):
                    self.errorMessage = "Lỗi không xác định: \(error)"
                    print("Unexpected error: \(error)")
                    self.activeAlert = .first
                    self.isAlertShowing = true
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã cập nhật trạng thái thành công: \(response)")
            })
            .store(in: &cancellables)
    }
    
    private func failToDeliverite() {
        APIManager.shared.failDeliverited(orderId: orderId, images: additionalImages)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.errorMessage = "Đã cập nhật trạng thái thành công, Đơn hàng sẽ phải chờ xét duyệt"
                    self.isAlertShowing = true
                    self.activeAlert = .first
                    print("Đã cập nhật trạng thái thành công")
                    self.isRequestSucesss = true
                case .failure(let error):
                    self.errorMessage = "Lỗi không xác định: \(error)"
                    print("Unexpected error: \(error)")
                    self.activeAlert = .first
                    self.isAlertShowing = true
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã cập nhật trạng thái thành công: \(response)")
            })
            .store(in: &cancellables)
    }
    
    private func finishRefund() {
        APIManager.shared.finishRefund(orderId: orderId, images: additionalImages)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                switch completion {
                case .finished:
                    self.errorMessage = "Đã cập nhật trạng thái thành công, Đơn hàng sẽ phải chờ xét duyệt"
                    self.isAlertShowing = true
                    self.activeAlert = .first
                    print("Đã cập nhật trạng thái thành công")
                    self.isRequestSucesss = true
                case .failure(let error):
                    self.errorMessage = "Lỗi không xác định: \(error)"
                    print("Unexpected error: \(error)")
                    self.activeAlert = .first
                    self.isAlertShowing = true
                }
            }, receiveValue: { response in
                // Xử lý response thành công
                print("Đã cập nhật trạng thái thành công: \(response)")
            })
            .store(in: &cancellables)
    }
}

// MARK: - PREVIEW
#Preview {
    DeliveriteConfirmedScreen(orderId: 1)
}
