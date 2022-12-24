//
//  InputFields.swift
//  iOSApp
//
//  Created by Neal Archival on 12/23/22.
//

import SwiftUI

struct InputField: View {
    var topLabel: String
    var placeholder: String
    @Binding var text: String
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text("\(topLabel)")
                    .font(.system(size: 20, weight: .medium))
                    .padding([.leading], 10)
                TextField(placeholder, text: $text)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .font(.system(size: 18, weight: .medium))
                    .padding([.leading], 15)
                    .frame(width: geometry.size.width * 0.95, height: 60)
                    .background(Color(hex: 0xD3D3D3))
                    .cornerRadius(12)
                    .frame(width: geometry.size.width)
            } // VStack
            .frame(width: geometry.size.width)
        } // GeometryReader
        .frame(height: 105)
    }
}

struct SecuredInputField: View {
    var topLabel: String
    var placeholder: String
    @Binding var text: String
    @State private var secured: Bool = true
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                Text("\(topLabel)")
                    .font(.system(size: 20, weight: .medium))
                    .padding([.leading], 10)
                HStack(spacing: 0) {
                    if !secured {
                        TextField(placeholder, text: $text)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .font(.system(size: 18, weight: .medium))
                            .frame(width: geometry.size.width * 0.8, height: 60)
                    } else {
                        SecureField(placeholder, text: $text)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .font(.system(size: 18, weight: .medium))
                            .frame(width: geometry.size.width * 0.8, height: 60)
                    }
                    Button(action: {
                        secured.toggle()
                    }) {
                        Image(systemName: secured ? "eye" : "eye.slash")
                            .font(.system(size: 18, weight: .medium))
                            .frame(height: 60)
                            .foregroundColor(Color.black)
                    }
                } // HStack
                .frame(width: geometry.size.width * 0.95, height: 60)
                .background(Color(hex: 0xD3D3D3))
                .cornerRadius(12)
                .frame(width: geometry.size.width)
            } // VStack
            .frame(width: geometry.size.width)
        } // GeometryReader
        .frame(height: 105)
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InputField(topLabel: "Username", placeholder: "Enter username", text: .constant(""))
            SecuredInputField(topLabel: "Password", placeholder: "Enter password", text: .constant(""))
        }
    }
}
