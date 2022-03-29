//
//  AssetBannerView.swift
//  MyAssets
//
//  Created by sae hun chung on 2022/03/11.
//

import SwiftUI

struct AssetBannerView: View {
    let bannerList: [AssetBanner] = [
        AssetBanner(title: "공지사항", description: "공지사항을 확인하세요!", backgroungColor: .red),
        AssetBanner(title: "주말 이벤트", description: "주말이벤트를 확인하세요!", backgroungColor: .yellow),
        AssetBanner(title: "깜짝 이벤트", description: "엄청난 이벤트에 놀라지 마세요!", backgroungColor: .green),
        AssetBanner(title: "봄 프로모션", description: "봄봄봄!", backgroungColor: .cyan)
    ]
    
    @State private var currentPage = 0
    
    var body: some View {
        let bannerCards = bannerList.map { BannerCard(banner: $0)
        }
        
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: bannerCards, currentPage: $currentPage)
            PageControl(numberOfPage: bannerList.count, currentPage: $currentPage)
                .frame(width: CGFloat(bannerCards.count * 18))
                .padding(.trailing)
        }
    }
}

struct AssetBannerView_Previews: PreviewProvider {
    static var previews: some View {
        AssetBannerView()
            .aspectRatio(5/2, contentMode: .fit)
    }
}
