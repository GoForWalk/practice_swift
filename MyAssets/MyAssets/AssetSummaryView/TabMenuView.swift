//
//  TabMenuView.swift
//  MyAssets
//
//  Created by sae hun chung on 2022/03/13.
//

import SwiftUI

struct TabMenuView: View {
    var tabs: [String]
    @Binding var selectedTap: Int
    
    // 변경내용 있으면 빨간점 표시
    @Binding var updated: CreditCardAmounts?
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { row in
                Button(
                    action: {
                        selectedTap = row
                        // 업데이트 시 빨간점 detecting
                        UserDefaults.standard.set(true, forKey: "creditCardUpdateChecked: \(row)")
                    },
                    label: {
                        VStack(spacing: 0) {
                            HStack {
                                if updated?.id == row {
                                    let checked  = UserDefaults.standard.bool(forKey: "creditCardUpdateChecked: \(row)")
                                    Circle()
                                        .fill(
                                            !checked
                                            ? Color.red
                                            : Color.clear
                                        )
                                        .frame(width: 6, height: 6)
                                        .offset(x: 2, y: -8)
                                } else {
                                    Circle()
                                        .fill(Color.clear)
                                        .frame(width: 6, height: 6, alignment: .center)
                                        .offset(x: 2, y: -8)
                                }
                                
                                Text(tabs[row])
                                    .font(.system(.headline))
                                    .foregroundColor(
                                        selectedTap == row
                                        ? .accentColor
                                        : .gray
                                    )
                                    .offset(x: -4, y: 0)
                            }
                            .frame(height: 52)
                            Rectangle()
                                .fill(
                                    selectedTap == row
                                    ? Color.secondary
                                    : Color.clear
                                )
                                .frame(height: 3)
                                .offset(x: 4, y: 0)
                        }
                    }
                
                )
                    .buttonStyle(PlainButtonStyle())
            }
        }
        .frame(height: 55)
    }
}

struct TabMenuView_Previews: PreviewProvider {
    static var previews: some View {
        TabMenuView(tabs: ["지난달 결제", "이번달 결제", "다음달 결제"],
                    selectedTap: .constant(1), // default 로 빨간알람 설정
                    updated: .constant(.currentMonth(amount: "10,000원")))
    }
}
