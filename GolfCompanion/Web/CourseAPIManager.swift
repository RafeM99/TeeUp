//
//  CourseAPIManager.swift
//  GolfCompanion
//
//  Created by Marriott, Rafe (NA) on 04/10/2025.
//

import Foundation

class CourseAPIManager {
    func fetchAllCourses(completion: @escaping (Course) -> Void) {
        var urlComponents = URLComponents(string: "https://api.golfcourseapi.com/v1/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "search_query", value: "")
        ]
        
        guard let url = urlComponents?.url else {
            print("Invalid url components url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("2NBEUHWTKI6HHVT6SDSQTZKR24", forHTTPHeaderField: "Authorization: Key")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(
            }
        }
    }
}
