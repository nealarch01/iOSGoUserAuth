//
//  HomeView.swift
//  iOSApp
//
//  Created by Neal Archival on 12/23/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var session: Session
    @StateObject private var viewModel = ViewModel()
    var body: some View {
        VStack(spacing: 15) {
            Text("Your Information: ")
                .font(.system(size: 28, weight: .bold))
            if viewModel.errorMessage != "" {
                Text("\(viewModel.errorMessage)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color.red)
                    .multilineTextAlignment(.center)
            } else {
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("**ID:** \(viewModel.account.id)")
                        Text("**Username:** \(viewModel.account.username)")
                        Text("**Email:** \(viewModel.account.email)")
                        Text("**Created at:** \(viewModel.account.created_at)")
                    }
                    .font(.system(size: 18))
                    Spacer()
                }
            }
            SubmitButton(text: "Logout", action: { logoutClicked() })
            Spacer()
        } // VStack
        .padding([.leading, .trailing])
        .onAppear {
            onAppearRender()
        }
    }
    
    private func onAppearRender() {
        Task {
            await viewModel.getAccountData(token: session.token)
        }
    }
    
    private func logoutClicked() {
        Task {
            await Logout(token: session.token)
        }
        session.resetToken()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Session(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2NzIwOTI2MjksImlhdCI6MTY3MTgzMzQyOSwiaWQiOjF9.anM3AklDsoys_Jt0__BUy4UCX38WnxuOMMpZABgASuo"))
    }
}
