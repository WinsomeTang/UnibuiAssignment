//
//  JobDetailRowView.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-24.
//

import SwiftUI

struct JobDetailRowView: View {
    let icon: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                Text(title)
                    .font(.title3)
            }
            Text(content)
                .foregroundColor(.gray)
        }
    }
}

//
//#Preview {
//    JobDetailRowView()
//}
