//
//  CourseAPIManager.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 04/10/2025.
//

import Foundation

class CourseAPIManager {
    enum Status: Sendable {
        case idle, loading
    }
    
    func searchCourses(query: String, completion: @escaping @Sendable ([Course]?, Status) -> Void) {
        completion(nil, .loading)
        
        var urlComponents = URLComponents(string: "https://api.golfcourseapi.com/v1/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "search_query", value: query)
        ]
        
        guard let url = urlComponents?.url else {
            print("Invalid url components url")
            DispatchQueue.main.async {
                completion([], .idle)
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Key 2NBEUHWTKI6HHVT6SDSQTZKR24", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion([], .idle)
                }
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let courseAPIresponse = try decoder.decode(CourseAPIResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(courseAPIresponse.courses, .idle)
                    }
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        completion([], .idle)
                    }
                }
            }
        }
        .resume()
    }
    
    enum CodingKeys: String, CodingKey {
        case courseId = "id"
        case clubName = "club_name"
        case courseName = "course_name"
        case teeName = "tee_name"
        case totalYards = "total_yards"
        case parTotal = "par_total"
        case location, tees, address, city, state, country, latitude, longitude, female, male, holes, par, yardage
    }
}
