//
//  AssetView.swift
//  MyAssets
//
//  Created by sae hun chung on 2022/03/10.
//

import SwiftUI

struct AssetView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    Spacer()
                    AssetMenuGridView()
                    AssetBannerView()
                        .aspectRatio(5/2, contentMode: .fit)
                    AssetSummaryView()
                        .environmentObject(AssetSummaryData())
                }
                
            }//: ScrollView
            .background(Color.gray.opacity(0.2))
            .navigationBarWithButtonStyle("내 자산")
        }//: NavigationView
        
    }// : body
}//: AssetView

struct AssetView_Previews: PreviewProvider {
    static var previews: some View {
        AssetView()
    }
}
