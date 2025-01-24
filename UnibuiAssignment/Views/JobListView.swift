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
        VStack() {
            // Search header
            VStack(alignment: .leading, spacing: 16) {
                Text("Jobs For You")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
                HStack{
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                        TextField("Job title or company name", text: $viewModel.searchText)
                            .autocorrectionDisabled(true)
                            .keyboardType(.default)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(style: StrokeStyle(lineWidth: 1)
                                   )
                            .foregroundColor(.black)
                        )
                    .offset(y:5)
                }
                .padding(.bottom, 30)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("Unibui_Orange").opacity(0.95),Color("Unibui_Orange").opacity(0.8), Color("Unibui_Orange").opacity(0.01)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Job listings
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.listOfJobs) { job in
                        JobCardView(job: job, viewModel: viewModel)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .offset(y: -35)
        }
        .onAppear {
            viewModel.listOfJobs = viewModel.loadJobs()
        }
    }
}


struct JobListView_Previews: PreviewProvider {
    static var previews: some View {
        JobListView()
    }
}
