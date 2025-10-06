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
    
    func searchCourses(query: String, completion: @escaping @Sendable ([Course]) -> Void) {
        var urlComponents = URLComponents(string: "https://api.golfcourseapi.com/v1/search")
        urlComponents?.queryItems = [
            URLQueryItem(name: "search_query", value: query)
        ]
        
        guard let url = urlComponents?.url else {
            print("Invalid URL components")
            DispatchQueue.main.async { completion([]) }
            return
        }
        
        // Debug: Log the request URL and query items
        print("CourseAPIManager: GET \(url.absoluteString)")
        if let items = urlComponents?.queryItems {
            let qs = items.map { "\($0.name)=\($0.value ?? "")" }.joined(separator: "&")
            print("Query items: \(qs)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Key 2NBEUHWTKI6HHVT6SDSQTZKR24", forHTTPHeaderField: "Authorization")
        
        // Debug: Log masked Authorization header
        if let auth = request.value(forHTTPHeaderField: "Authorization") {
            let masked = auth.count > 12 ? String(auth.prefix(12)) + "…" : auth
            print("Authorization header: \(masked)")
        }
        
        // Capture the URL string before the closure to avoid Sendable warning
        let urlString = url.absoluteString
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTPURLResponse")
                DispatchQueue.main.async { completion([]) }
                return
            }
            
            // Debug: Log HTTP status and URL using captured urlString
            print("HTTP \(httpResponse.statusCode) for \(urlString)")

            guard (200...299).contains(httpResponse.statusCode) else {
                let status = httpResponse.statusCode
                print("HTTP error status: \(status)")
                if let data = data, let body = String(data: data, encoding: .utf8) {
                    print("Response body: \(body)")
                }
                DispatchQueue.main.async { completion([]) }
                return
            }

            guard let data = data else {
                print("No data returned")
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(CourseAPIResponse.self, from: data)
                // Debug: Log decoded course count
                print("Decoded courses count: \(decodedResponse.courses.count)")
                DispatchQueue.main.async { completion(decodedResponse.courses) }
            } catch {
                print("Decoding error: \(error)")
                if let body = String(data: data, encoding: .utf8) {
                    print("Raw body: \(body)")
                }
                DispatchQueue.main.async { completion([]) }
            }
        }
        .resume()
    }
}
