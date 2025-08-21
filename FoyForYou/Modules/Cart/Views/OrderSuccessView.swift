//
//  OrderSuccessView.swift
//  FoyForYou
//
//  Created by Mohd Zuber Rehmani on 21/08/25.
//

import SwiftUI

struct SuccessFullScreen: View {
    let paymentMessage: String
    var onFinish: () -> Void
    
    @State private var showCheckmark = false
    @State private var showMessage = false
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                if showCheckmark {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.green)
                        .scaleEffect(showCheckmark ? 1.0 : 0.5)
                        .animation(.spring(response: 0.6, dampingFraction: 0.5), value: showCheckmark)
                }
                
                if showMessage {
                    Text("Order Placed Successfully 🎉\n\(paymentMessage)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showCheckmark = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showMessage = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    onFinish()
                }
            }
        }
    }
}
