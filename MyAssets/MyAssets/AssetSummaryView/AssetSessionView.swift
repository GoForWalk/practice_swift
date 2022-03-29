//
//  AssetSessionView.swift
//  MyAssets
//
//  Created by sae hun chung on 2022/03/12.
//

import SwiftUI

struct AssetSessionView: View {
    
    @ObservedObject var assetSection: Asset
    
    var body: some View {
        VStack(spacing: 20) {
            AssetSectionHeaderView(title: assetSection.type.title)
            ForEach(assetSection.data){ asset in
                HStack {
                    Text(asset.title)
                        .font(.title)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(asset.amount)
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Divider()
            }
        }
        .padding()
    }
}//: AssetSessionView

struct AssetSessionView_Previews: PreviewProvider {
    static var previews: some View {
        let asset = Asset(
            id: 0,
            type: .bankAccount,
            data: [
                AssetData(id: 0, title: "신한은행", amount: "5,000,000원"),
                AssetData(id: 1, title: "국민은행", amount: "12,000,000원"),
                AssetData(id: 2, title: "카카오은행", amount: "100,000원")
                  ]
        )
        
        AssetSessionView(assetSection: asset)
    }
}
