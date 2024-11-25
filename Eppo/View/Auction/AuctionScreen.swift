//
// Created by Letter ♥
//
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionScreen: View {
    // MARK: - PROPERTY
    @State var searchText: String = ""
    @State var viewModel: AuctionViewModel = AuctionViewModel()
    @State var isCalendarToggle: Bool = false
    
    @State private var date = Date()
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CustomAvatarHeader(withClose: false)
                
                HStack(spacing: 15) {
                    SearchBar(searchText: $searchText)

                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                        .overlay {
                            DatePicker(selection: $date, displayedComponents: .date) {}
                                .labelsHidden()
                                .contentShape(Rectangle())
                                .opacity(0.011)
                        }
                        .onChange(of: date) { oldValue, newValue in
                            viewModel.selectedDate = newValue
                            if oldValue != newValue {
                                self.viewModel.loadMoreAuctiuonRoomsByDate()
                            }
                        }
                    
                }
                .padding()
                
                if viewModel.selectedDate != nil {
                    Button {
                        viewModel.selectedDate = nil
                        viewModel.resetAllPage()
                        viewModel.loadMoreAutionRooms()
                    } label: {
                        HStack {
                            Text("Xoá bộ lọc")
                            
                            Spacer()
                        }
                        .padding(.bottom)
                        .padding(.horizontal)
                    }
                }
                
                if viewModel.isEmptyResult {
                    Text("Không tìm thấy kết quả")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                        ForEach(viewModel.rooms, id: \.self) { room in
                            NavigationLink {
                                AuctionDetailScreen(roomId: room.roomId)
                            } label: {
                                ToAuctionItem(imageURL: room.plant.mainImage, itemName: room.plant.name, price: room.plant.finalPrice, time: room.activeDate)
                            }
                        }
                    }
                    .padding(.bottom, 70)
                    .padding(.horizontal, 8)
                }
                
                Spacer()
            }
            //            .background(Color.init(uiColor: UIColor.systemGray5))
            .ignoresSafeArea(.all)
            .onAppear {
                viewModel.resetAllPage()
                viewModel.loadMoreAutionRooms()
            }
        }
    }
    
    
    func reformatDateString(_ dateString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        // Convert the string to a Date object
        guard let date = inputFormatter.date(from: dateString) else {
            return nil // Return nil if the date string is invalid
        }
        
        // Create a DateFormatter for the desired output format
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm dd/MM"
        
        // Convert the Date object back to a string in the new format
        return outputFormatter.string(from: date)
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionScreen()
}
