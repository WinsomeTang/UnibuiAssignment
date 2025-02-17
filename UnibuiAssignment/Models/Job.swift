//
//  Job.swift
//  UnibuiAssignment
//
//  Created by Winsome Tang on 2025-01-20.
//

import Foundation

struct Job: Identifiable, Codable {
    let id = UUID() //Differentiate same positions but from different businesses
    let jobTitle: String
    let companyName: String
    let location: String
    let jobDescription: String
    let requirements: String
    
    enum CodingKeys: String, CodingKey {
        case jobTitle = "Job Title"
        case companyName = "Company Name"
        case location = "Location"
        case jobDescription = "Job Description"
        case requirements = "Requirements"
    }
}

enum JobError: Error {
    case fileNotFound
    case invalidData
    case parsingError
    case locationError
    
    var message: String {
        switch self {
            case .fileNotFound: return "Unable to load jobs data"
            case .invalidData: return "Invalid job data format"
            case .parsingError: return "Error processing jobs data"
            case .locationError: return "Unable to load location preview"
        }
    }
}
