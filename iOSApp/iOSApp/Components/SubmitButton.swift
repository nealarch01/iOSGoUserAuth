//
//  SubmitButton.swift
//  iOSApp
//
//  Created by Neal Archival on 12/23/22.
//

import SwiftUI

struct SubmitButton: View {
    var text: String
    var action: () async -> Void
    var body: some View {
        GeometryReader { geometry in
            Button(action: {
                Task {
                    await action()
                }
            }) {
                Text("\(text)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.white)
                    .frame(width: geometry.size.width * 0.55, height: 60)
                    .background(Color(hex: 0x6A5ACD))
                    .cornerRadius(12)
                    .frame(width: geometry.size.width) // Centers the button
            } // Button
        } // GeometryReader
        .frame(height: 60)
    }
}

struct SubmitButton_Previews: PreviewProvider {
    static var previews: some View {
        SubmitButton(text: "", action: {})
    }
}
