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

    func loadJobs() -> [Job] {
            guard let filePath = Bundle.main.path(forResource: "jobs", ofType: "csv") else {
                print("Error - file not found")
                return []
            }
            var jobs: [Job] = []
            
            do {
                let jobData = try String(contentsOfFile: filePath, encoding: .utf8)
                let rows = jobData.split(separator: "\n")
                
                for row in rows.dropFirst() where !row.isEmpty {
                    var columns: [String] = []
                    var currentField = ""
                    var insideQuotes = false
                    
                    //loop for differentiating characters inside the double quotes verses being separated by the comma and also without double quotes
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
                    
                    guard columns.count >= 5 else { continue }
                    
                    let job = Job(
                        jobTitle: columns[0],
                        companyName: columns[1],
                        location: columns[2],
                        jobDescription: columns[3],
                        requirements: columns[4]
                    )
                    jobs.append(job)
                }
                print(jobs)
            } catch {
                print("Parsing CSV file failed")
            }
        print(jobs)
            return jobs
        }
}
