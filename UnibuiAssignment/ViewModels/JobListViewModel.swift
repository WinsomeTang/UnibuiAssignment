//
//  JobViewModel.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-20.
//

import Foundation

class JobListViewModel: ObservableObject {
    @Published var listOfJobs: [Job] = []
    @Published var favouriteJobs: Set<UUID> = []
    @Published var searchText: String = ""
    
//    var filteredJobs: [Job] {
//        if searchText.isEmpty {
//            return listOfJobs
//        }
//        return listOfJobs.filter { listOfJobs in
//            listOfJobs.jobTitle.localizedCaseInsensitiveContains(searchText) ||
//            listOfJobs.companyName.localizedCaseInsensitiveContains(searchText)
//        }
//    }

    func loadJobs() -> [Job] {
        guard let filePath = Bundle.main.path(forResource: "jobs", ofType: "csv") else {
                print("Error - file not found")
            return []
        }
        var jobs: [Job] = []
        
        do{
            let jobData = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = jobData.split(separator: "\n")
            
            for row in rows.dropFirst() where !row.isEmpty {
                let columns = row.components(separatedBy: ",")
                
                // Ensure we have all required columns
                guard columns.count >= 5 else {
                    continue // Skip invalid rows
                }
                
                // Create job object
                let job = Job(
                    jobTitle: columns[0].trimmingCharacters(in: .whitespacesAndNewlines),
                    companyName: columns[1].trimmingCharacters(in: .whitespacesAndNewlines),
                    location: columns[2].trimmingCharacters(in: .whitespacesAndNewlines),
                    jobDescription: columns[3].trimmingCharacters(in: .whitespacesAndNewlines),
                    requirements: columns[4].trimmingCharacters(in: .whitespacesAndNewlines)
                )
                jobs.append(job)
            }
        } catch {
            print("Parsing CSV file failed")
        }
        return jobs
    }
    
//    func toggleFavourite(for jobId: UUID) {
//        if favouriteJobs.contains(jobId) {
//            favouriteJobs.remove(jobId)
//        } else {
//            favouriteJobs.insert(jobId)
//        }
//    }
}
