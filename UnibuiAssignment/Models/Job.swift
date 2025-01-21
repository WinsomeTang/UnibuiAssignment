//
//  Job.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-20.
//

import Foundation

struct Job: Codable, Identifiable{
    let id = UUID() //Differentiate same positions but from different businesses
    let jobTitle: String
    let companyName: String
    let location: String
    let jobDescription: String
    let requirements: String
    
    init(jobTitle: String, companyName: String, location: String, jobDescription: String, requirements: String){
        self.jobTitle = jobTitle
        self.companyName = companyName
        self.location = location
        self.jobDescription = jobDescription
        self.requirements = requirements
    }
}
