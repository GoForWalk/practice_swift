//
//  BannerCard.swift
//  MyAssets
//
//  Created by sae hun chung on 2022/03/11.
//

import SwiftUI

struct BannerCard: View {
    var banner: AssetBanner

    var body: some View {
        Color(banner.backgroungColor)
            .overlay(
                VStack {
                    Text(banner.title)
                        .font(.title)
                    Text(banner.description)
                        .font(.subheadline)
                }
                
            )
        
    }
}

struct BannerCard_Previews: PreviewProvider {
    static var previews: some View {
        let banner0 = AssetBanner(title: "공지사항", description: "추가된 공지사항을 확인하세요.", backgroungColor: .red)
        BannerCard(banner: banner0)
    }
}
