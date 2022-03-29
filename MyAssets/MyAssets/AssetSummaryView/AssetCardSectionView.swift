//
//  AssetCardSectionView.swift
//  MyAssets
//
//  Created by sae hun chung on 2022/03/14.
//

import SwiftUI

struct AssetCardSectionView: View {
    @State private var selectedTap = 1 // default 값
    @ObservedObject var asset: Asset
    
    var assetData: [AssetData] {
        return asset.data
    }
    
    var body: some View {
        VStack {
            AssetSectionHeaderView(title: asset.type.title)
            TabMenuView(
                tabs: ["지난달 결제", "이번달 결제", "다음달 결제"],
                selectedTap: $selectedTap,
                updated: .constant(.nextMonth(amount: "10,000"))
            )
            TabView(
                selection: $selectedTap,
                content: {
                    ForEach(0...2, id: \.self) { i in
                        VStack {
                            ForEach(asset.data) { data in
                                HStack {
                                    Text(data.title)
                                        .font(.title)
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(data.creditCardAmounts![i].amount)
                                        .font(.title2)
                                        .foregroundColor(.primary)
                                }
                                Divider()
                            }
                        }
                        .tag(i)
                    }
                }
            )
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
        .padding()
    }//: body
}//: AssetCardSectionView


struct AssetCardSectionView_Previews: PreviewProvider {
    static var previews: some View {
        
        let asset = AssetSummaryData().assets[5]
        
        AssetCardSectionView(asset: asset)
    }
}
