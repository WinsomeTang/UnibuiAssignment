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
                    JobDetailRowView(icon: "building.2", title: "Company Name", content: job.companyName)
                    JobDetailRowView(icon: "briefcase", title: "Job Description", content: job.jobDescription)
                    JobDetailRowView(icon: "list.clipboard", title: "Job Requirement", content: job.requirements)
                    JobDetailRowView(icon: "mappin.and.ellipse", title: "Location", content: job.location)
                    LookAroundPreview(scene: $selectedScene)
                        .frame(height: 200)
                        .cornerRadius(12)
                        .task {
                            await searchLocation()
                        }
                }
                .padding(.horizontal, 24)
//                .padding(.bottom, 1)
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
            }
        } catch {
            print("Search error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    JobDetailView(job: Job(
        jobTitle: "Network Administrator",
        companyName: "Unibui",
        location: "Ontario Street 123, Mississauga, Ontario",
        jobDescription: "Blah Blah Blah",
        requirements: "Blah Blah Blah"
    ))
}
