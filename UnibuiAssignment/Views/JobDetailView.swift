//
//  JobDetailView.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-22.
//

import SwiftUI

struct JobDetailView: View {
    @StateObject var viewModel = JobListViewModel()
    @Environment(\.dismiss) var dismiss
    let job: Job
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: { dismiss() }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.unibuiOrange)
                .padding(.horizontal)
            }
            
            Group {
                Text("Job Description")
                    .font(.headline)
                Text(job.jobDescription)
                
                Text("Requirements")
                    .font(.headline)
                Text(job.requirements)
            }
            .padding(.horizontal)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(job.jobTitle)
    }
}

//
//#Preview {
//    JobDetailView()
//}
