//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct PopoverTest: View {
    // MARK: - PROPERTY
    @State var popup = false

    // MARK: - BODY

    var body: some View {
        Button {
            withAnimation(.easeInOut) {
                popup.toggle()
            }
        } label: {
            Text("A")
        }
        .popover(isPresented: $popup) {
            VStack(alignment: .leading) {
                ScrollView(.vertical) {
                    PopoverRow(title: "1. Mục đích", contents: [
                        "Tạo sân chơi lành mạnh, công bằng và thú vị cho những người yêu cây cảnh muốn sở hữu hoặc thuê các tác phẩm độc đáo thông qua hình thức đấu giá."
                    ])
                    PopoverRow(title: "2. Quy định chung", contents: [
                        "Tất cả người tham gia đấu giá phải đăng ký tài khoản hợp lệ trên nền tảng đấu giá và có số dư ví điện tử tối thiểu để đảm bảo thanh toán khi trúng đấu giá (BR-31).",
                        "Người tham gia cần cung cấp thông tin chính xác, bao gồm họ tên, số điện thoại, email, và địa chỉ nhận hàng (nếu trúng đấu giá).",
                        "Người tham gia phải đồng ý với các điều khoản và quy định của chương trình đấu giá."
                    ])
                    PopoverRow(title: "3. Thời gian và hình thức đấu giá", contents: [
                        "Thời gian bắt đầu và kết thúc: Mỗi phiên đấu giá sẽ được thông báo cụ thể trên trang đấu giá hoặc ứng dụng.",
                        "Hình thức đấu giá: Đấu giá trực tuyến.",
                        "Bước giá (Bid increment): Mức tăng giá tối thiểu được quy định cho mỗi phiên đấu giá.",
                        "Chỉ người có số dư ví đủ để trả giá mới được tham gia đặt giá (BR-19)."
                    ])
                    PopoverRow(title: "4. Cách tham gia đấu giá", contents: [
                        "Bước 1: Truy cập vào sản phẩm muốn đấu giá.",
                        "Bước 2: Nhập số tiền muốn đấu giá (phải cao hơn giá hiện tại và tuân theo bước giá quy định).",
                        "Bước 3: Xác nhận đặt giá.",
                        "Bước 4: Theo dõi quá trình đấu giá để nâng giá nếu cần."
                    ])
                    PopoverRow(title: "5. Quy định đối với người trúng đấu giá", contents: [
                        "Người trúng đấu giá: Là người đưa ra mức giá cao nhất khi phiên đấu giá kết thúc.",
                        "Thông báo: Sau khi phiên đấu giá kết thúc, người trúng đấu giá sẽ nhận được thông báo qua email hoặc ứng dụng.",
                        "Thanh toán: Người trúng đấu giá sẽ bị trừ tiền từ ví điện tử ngay sau khi đấu giá kết thúc (BR-18).",
                        "Nếu không hoàn tất thanh toán trong thời gian quy định, quyền trúng đấu giá sẽ bị hủy (BR-20).",
                        "Giao nhận sản phẩm: Sản phẩm sẽ chỉ được giao sau khi hệ thống xác nhận đã nhận đủ tiền (BR-32).",
                        "Phí vận chuyển do người mua chịu, được tính theo chiều cao, rộng và dài của cây (BR-03)."
                    ])
                    PopoverRow(title: "6. Các quy định khác", contents: [
                        "Hủy kết quả đấu giá: Nếu người trúng đấu giá không thực hiện giao dịch thành công sau 3 lần, đơn hàng sẽ được giữ lại cho chủ sở hữu trong 2 tháng và không được hoàn lại tiền (BR-20).",
                        "Hành vi gian lận: Các hành vi gian lận sẽ bị xử lý nghiêm, bao gồm khóa tài khoản và cấm tham gia đấu giá vĩnh viễn.",
                        "Trường hợp khiếu nại: Người tham gia đấu giá không được hoàn lại phí đăng ký tham gia đấu giá nếu không tham gia hoặc không trúng đấu giá (BR-17, BR-33)."
                    ])
                    PopoverRow(title: "7. Quy định đối với cây đấu giá", contents: [
                        "Cây tham gia đấu giá phải có nguồn gốc rõ ràng và được kiểm định bởi chuyên gia bonsai (BR-24).",
                        "Khách hàng trúng đấu giá sẽ không được trả lại cây nếu không có lý do hợp lệ (BR-27)."
                    ])
                    PopoverRow(title: "8. Quy định bảo mật thông tin", contents: [
                        "Thông tin cá nhân của khách hàng (bao gồm tên, địa chỉ, số điện thoại) chỉ được sử dụng cho mục đích xử lý đơn hàng và không được chia sẻ nếu chưa có sự đồng ý của khách hàng (BR-30)."
                    ])
                    PopoverRow(title: "9. Tiền đặt cọc và hoàn tiền", contents: [
                        "Người tham gia đấu giá phải đặt cọc trước khi tham gia. Tiền đặt cọc sẽ được hoàn lại nếu không trúng đấu giá (BR-35).",
                        "Nếu khách hàng thuê cây, tiền đặt cọc sẽ không được hoàn lại nếu khách hàng vi phạm hợp đồng (BR-34)."
                    ])
                    PopoverRow(title: "10. Lưu ý quan trọng", contents: [
                        "Mọi mức giá đặt đều được xem là cam kết mua hàng.",
                        "Khách hàng cần đọc kỹ thông tin sản phẩm trước khi tham gia đấu giá. Cây đã đấu giá thành công sẽ không được trả lại, trừ lý do hợp lệ."
                    ])
                }
                .scrollIndicators(.hidden)
            }
            .frame(width: UIScreen.main.bounds.size.width - 100, height: 300)
            .padding()
            .presentationCompactAdaptation(.popover)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    PopoverTest()
}
