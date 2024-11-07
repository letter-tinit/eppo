//
//  OwnerHome.swift
//  Eppo
//
//  Created by Letter on 23/10/2024.
//

import SwiftUI

struct OwnerHome: View {
    @State var searchText: String = ""
    @State private var date = Date()
    
    private var data  = Array(1...10)
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 160))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            CustomAvatarHeader(name: "Nguyễn Văn A", image: Image("avatar"), withClose: false)
            
            // MARK: - SEARCH BAR
            HStack(spacing: 14) {
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
            .padding()
            
            // MARK: - CONTENT
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: adaptiveColumn, spacing: 20) {
                    Section {
                        ForEach(data, id: \.self) { item in
                            NavigationLink {
                                OwnerItemDetailScreen()
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    Image("sample-bonsai-01")
                                        .resizable()
                                        .frame(width: 160, height: 100, alignment: .top)
                                        .scaledToFit()
                                        .clipped()
                                    
                                    VStack(alignment: .leading, spacing: 5){
                                        Text("Sen Đá Kim Cương Haworthia Cooperi")
                                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                                            .multilineTextAlignment(.leading)
                                        
                                        Text("30/07/2024  - 10:35:50")
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                        
                                        Text("Đang cho thuê")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.blue)
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 10)
                                }
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .shadow(color: .black.opacity(0.5), radius: 2, y: 4)
                            }
                        }
                    }
                }
                .padding(.bottom, 100)
                .background(.white)
            }
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview {
    OwnerHome()
}
