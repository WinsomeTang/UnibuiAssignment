//
//  JobDetailView.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-22.
//

import SwiftUI
import MapKit

struct JobDetailView: View {
    @ObservedObject var viewModel = JobListViewModel()
    @Environment(\.dismiss) var dismiss
    let job: Job
    @State private var selectedScene: MKLookAroundScene?
    @State private var locationError = false
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button(action: { viewModel.toggleFavorite(for: job.id) }) {
                        Image(systemName: viewModel.favouriteJobs.contains(job.id) ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(viewModel.favouriteJobs.contains(job.id) ? .unibuiOrange : .gray)
                    }
                }
                .padding(.horizontal, 24)
                
                VStack(spacing: 16) {
                    Image(systemName: "photo")
                        .font(.system(size: 40))
                        .frame(width: 100, height: 100)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text(job.jobTitle)
                        .font(.title)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 15) {
                    JobDetailRowView(icon: "building.2.fill", title: "Company Name", content: job.companyName)
                    JobDetailRowView(icon: "briefcase.fill", title: "Job Description", content: job.jobDescription)
                    JobDetailRowView(icon: "list.clipboard.fill", title: "Job Requirement", content: job.requirements)
                    JobDetailRowView(icon: "mappin.and.ellipse.fill", title: "Location", content: job.location)

                    if locationError {
                        ContentUnavailableView("No location preview available :(", systemImage: "eye.slash.fill")
                           .frame(height: 200)
                           .overlay(
                               RoundedRectangle(cornerRadius: 12)
                                   .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                           )
                    }
                    else{
                        LookAroundPreview(scene: $selectedScene)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .task {
                                await searchLocation()
                            }
                    }
                    
                }
                .padding(.horizontal, 24)
                
                Button(action: {}) {
                    Text("I need this job!")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("Unibui_Orange"))
                        .cornerRadius(30)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 200)
            }
        }
        .navigationBarHidden(true)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { }
        } message: {
            Text(viewModel.error?.message ?? "An unknown error occurred")
        }
    }
    
    func searchLocation() async {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = job.location
        searchRequest.resultTypes = .address
        
        let search = MKLocalSearch(request: searchRequest)
        
        do {
            let response = try await search.start()
            if let mapItem = response.mapItems.first {
                let lookAroundRequest = MKLookAroundSceneRequest(mapItem: mapItem)
                selectedScene = try? await lookAroundRequest.scene
                if selectedScene == nil {
                    locationError = true
                }
            } else {
                locationError = true
            }
        } catch {
            locationError = true
        }
    }
}

#Preview {
    JobDetailView(job: Job(
        jobTitle: "Network Administrator",
        companyName: "Some Company",
        location: "Mississauga, Ontario",
        jobDescription: "Blah Blah Blah",
        requirements: "Blah Blah Blah"
    ))
}
