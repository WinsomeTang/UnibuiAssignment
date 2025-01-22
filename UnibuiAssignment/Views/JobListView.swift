//
//  ContentView.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-20.
//

import SwiftUI

struct JobListView: View {
    @StateObject private var viewModel = JobListViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.listOfJobs) { job in
                VStack(alignment: .leading, spacing: 8) {
                    Text(job.jobTitle)
                        .font(.headline)
                    
                    Text(job.companyName)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(job.location.replacingOccurrences(of: "\"", with: ""))
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Jobs")
            .onAppear {
                viewModel.listOfJobs = viewModel.loadJobs()
            }
        }
    }
}

struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        JobListView()
    }
}
