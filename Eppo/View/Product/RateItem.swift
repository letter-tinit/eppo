//
// Created by Letter ♥
// 
// https://github.com/tinit4ever
//

import SwiftUI

struct RateItem: View {
    // MARK: - PROPERTY
    @State var feedback: FeedBack
    
    init(feedback: FeedBack) {
        self.feedback = feedback
    }

    // MARK: - BODY

    var body: some View {
        HStack(alignment: .top) {
            CustomCircleAsyncImage(imageUrl: feedback.user.imageUrl, size: 40)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(feedback.user.fullName)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(.black)
                
                RatingView(rating: feedback.rating, font: .subheadline)
                
                Text(feedback.description)
                    .font(.subheadline)
                
                HStack {
                    ForEach(feedback.imageFeedbacks) { image in
                        CustomRoundedAsyncImage(imageUrl: image.imageUrl, width: 60, height: 80)
                        
                    }
                }
            }
            .padding(.top, 6)
        }
    }
}
