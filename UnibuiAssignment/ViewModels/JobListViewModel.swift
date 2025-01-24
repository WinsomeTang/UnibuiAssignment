//
//  JobViewModel.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-20.
//

import Foundation

class JobListViewModel: ObservableObject {
    @Published var listOfJobs: [Job] = []
    @Published var error: JobError?
    @Published var showError = false
    @Published var searchText: String = "" {
        didSet {
            filterJobs()
        }
    }
    @Published var favouriteJobs: Set<UUID> = [] {
        didSet {
            sortJobsByFavorites()
        }
    }
    private var allJobs: [Job] = []
    
    private func filterJobs() {
        if searchText.isEmpty {
            listOfJobs = allJobs
        } else {
            listOfJobs = allJobs.filter { job in
                job.jobTitle.localizedCaseInsensitiveContains(searchText) ||
                job.companyName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func loadJobs() {
        guard let filePath = Bundle.main.path(forResource: "jobs", ofType: "csv") else {
            error = .fileNotFound
            showError = true
            return
        }
        
        do {
            let jobData = try String(contentsOfFile: filePath, encoding: .utf8)
            let rows = jobData.split(separator: "\n")
            var jobs: [Job] = []
            
            for row in rows.dropFirst() where !row.isEmpty {
                do {
                    let job = try parseJob(from: row)
                    jobs.append(job)
                } catch {
                    print("Error parsing row: \(error)")
                    continue
                }
            }
            
            if jobs.isEmpty {
                error = .invalidData
                showError = true
            }
            
            self.allJobs = jobs
            self.listOfJobs = jobs
            
        } catch {
            self.error = .parsingError
            showError = true
        }
    }
    
    private func parseJob(from row: String.SubSequence) throws -> Job {
        var columns: [String] = []
        var currentField = ""
        var insideQuotes = false
        
        for character in row {
            if character == "\"" {
                insideQuotes.toggle()
            } else if character == "," && !insideQuotes {
                columns.append(currentField.trimmingCharacters(in: .init(charactersIn: "\"")))
                currentField = ""
            } else {
                currentField.append(character)
            }
        }
        columns.append(currentField.trimmingCharacters(in: .init(charactersIn: "\"")))
        
        guard columns.count >= 5 else {
            throw JobError.invalidData
        }
        
        return Job(
            jobTitle: columns[0],
            companyName: columns[1],
            location: columns[2],
            jobDescription: columns[3],
            requirements: columns[4]
        )
    }
    
    private func sortJobsByFavorites() {
            listOfJobs.sort { job1, job2 in
                switch (favouriteJobs.contains(job1.id), favouriteJobs.contains(job2.id)) {
                case (true, false): return true
                case (false, true): return false
                default: return false
                }
            }
        }
        
        func toggleFavorite(for jobId: UUID) {
            if favouriteJobs.contains(jobId) {
                favouriteJobs.remove(jobId)
            } else {
                favouriteJobs.insert(jobId)
            }
        }
}
