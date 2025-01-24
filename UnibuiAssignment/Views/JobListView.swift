//
//  ContentView.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-20.
//
import SwiftUI

struct JobListView: View {
    @StateObject private var viewModel = JobListViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // Search header
            VStack(alignment: .leading, spacing: 16) {
                
                Text("I need a job ...")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                HStack{
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Job title or company name", text: $searchText)

                    }
                    .padding()
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(style: StrokeStyle(lineWidth: 1)
                                   )
                            .foregroundColor(.black)
                        )
                    Button(action: {}) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                            .padding(18)
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                }
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("Unibui_Orange").opacity(0.95), Color("Unibui_Orange").opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )

            )
            .presentationCornerRadius(50)
            
            // Job listings
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.listOfJobs) { job in
                        JobCard(job: job)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .onAppear {
            viewModel.listOfJobs = viewModel.loadJobs()
        }
    }
}

struct JobCard: View {
    let job: Job
    @State private var isFavorite = false
    @State private var showingDetail = false
    
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
                
                Button(action: { isFavorite.toggle() }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .unibuiOrange : .gray)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .gray.opacity(0.5), radius: 7)
        }
        .buttonStyle(PlainButtonStyle())
        .fullScreenCover(isPresented: $showingDetail) {
            NavigationView {
                JobDetailView(job: job)
            }
        }
    }
}

struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        JobListView()
    }
}
