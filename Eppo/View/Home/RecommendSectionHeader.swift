//
//  RecommendSectionHeader.swift
//  Eppo
//
//  Created by Letter on 25/09/2024.
//

import SwiftUI

struct RecommendSectionHeader: View {
    enum RecomendOption: String, CaseIterable {
        case forYou = "Dành Cho Bạn"
        case forHire = "Cho Thuê"
        
        var flag: String {
            return self.rawValue
        }
    }
    
    @Namespace private var animation
    
    @State private var selectedOption: RecomendOption = .forYou
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Button {
                withAnimation {
                    selectedOption = .forYou
                }
            } label: {
                Text(RecomendOption.forYou.rawValue)
                    .frame(maxWidth: .infinity)
                    .padding(6)
            }
            .foregroundColor(selectedOption == .forYou ? .orange : .primary)
            .background(selectedOption == .forYou ? Color.white : Color(uiColor: UIColor.systemGray5))
            .clipShape(
                .rect(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 20
                )
            )
            .matchedGeometryEffect(id: "forYou", in: animation)
            
            Button {
                withAnimation {
                    selectedOption = .forHire
                }
            } label: {
                Text(RecomendOption.forHire.rawValue)
                    .frame(maxWidth: .infinity)
                    .padding(6)
            }
            .foregroundColor(selectedOption == .forHire ? .orange : .primary)
            .background(selectedOption == .forHire ? Color.white : Color(uiColor: UIColor.systemGray5))
            .clipShape(
                .rect(
                    topLeadingRadius: 20,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 0
                )
            )
            .matchedGeometryEffect(id: "forHire", in: animation)
        }
        .padding(.top, 4)
        .frame(height: 30)
        .background(Color(uiColor: UIColor.systemGray5))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RecommendSectionHeader()
}
