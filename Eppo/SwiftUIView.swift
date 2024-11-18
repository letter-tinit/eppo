//import SwiftUI
//
//// Mẫu ứng dụng SwiftUI với TabView
//struct ContentView: View {
//    @State private var selection: Int = 0  // Lưu trữ giá trị tab đã chọn
//    @State private var browseTabPath: [String] = []  // Lưu trữ đường dẫn trong tab Browse
//    
//    var body: some View {
//        TabView {
//            Tab
//            
//            Tab("Received", systemImage: "tray.and.arrow.down.fill") {
//                HomeScreen()
//            }
//            .badge(2)
//            
//            
//            Tab("Sent", systemImage: "tray.and.arrow.up.fill") {
//                ProfileScreen()
//            }
//            
//            
//            Tab("Account", systemImage: "person.crop.circle.fill") {
//                NotificationScreen()
//            }
//            .badge("!")
//        }
//        
//    }
//}
//#Preview {
//    ContentView()
//}
