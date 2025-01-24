//
//  JobCardView.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-24.
//

import SwiftUI

struct JobCardView: View {
    let job: Job
    @State private var isFavorite = false
    @State private var showingDetail = false
    @StateObject var viewModel: JobListViewModel
    var body: some View {
        Button(action: { showingDetail = true }) {
            HStack(spacing: 16) {
                Image(systemName: "photo.fill")
                    .frame(width: 65, height: 65)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(job.jobTitle)
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: "building.2.fill")
                        Text(job.companyName)
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundStyle(.black)
                        Text(job.location)
                            .foregroundStyle(.unibuiOrange)
                    }
                    .font(.subheadline)
                }
                
                Spacer()
                
                Button(action: { viewModel.toggleFavorite(for: job.id) }) {
                            Image(systemName: viewModel.favouriteJobs.contains(job.id) ? "heart.fill" : "heart")
                                .foregroundColor(viewModel.favouriteJobs.contains(job.id) ? .unibuiOrange : .gray)
                        }
                .frame(width: 32, height: 32)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingDetail) {
            NavigationView {
                JobDetailView(viewModel: viewModel, job: job)
            }
        }
    }
}

//#Preview {
//    JobCardView()
//}
