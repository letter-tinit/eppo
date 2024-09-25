//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct AuctionRoomScreen: View {
    // MARK: - PROPERTY
    @State var searchText: String = ""
    @State private var date = Date()

    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                CustomAvatarHeader(name: "Nguyễn Văn An", image: Image("avatar"), withClose: true, isReturnMain: true)
                
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
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.black)
                        
                        
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                        ForEach(data, id: \.self) { item in
                            NavigationLink {
                                AuctionRoomDetailScreen()
                            } label: {
                                AuctionRoomItem(image: Image("sample-bonsai-01"), itemName: "Sen Đá Kim Cương Haworthia Cooperi", roomNumber: "P100", time: "1/08 - 10:30")
                            }
                        }
                    }
                    .padding(.bottom, 70)
                    .padding(.horizontal, 8)
                }
                
                Spacer()
            }
            .ignoresSafeArea(.all)
        }
        .navigationBarBackButtonHidden()
    }
}

// MARK: - PREVIEW
#Preview {
    AuctionRoomScreen()
}
