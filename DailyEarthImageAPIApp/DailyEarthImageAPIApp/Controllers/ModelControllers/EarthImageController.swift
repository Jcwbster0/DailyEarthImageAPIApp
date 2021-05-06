//
//  EarthImageController.swift
//  DailyEarthImageAPIApp
//
//  Created by Justin Webster on 5/5/21.
//

import UIKit

class EarthImageController {
    
    static let baseURL = URL(string: "https://epic.gsfc.nasa.gov/api/natural/")
    static let baseImageURL = URL(string: "https://epic.gsfc.nasa.gov/archive/natural")
    
    static func fetchEarthImageData (apiKey: String = "api_key", completion: @escaping (Result<EarthImage, EarthImageError>) -> Void) {
        
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let APIKey = URLQueryItem(name: apiKey, value: "ibTjKK0aMi5GGlcIgZgdHdHN4SCV8p48YUBC6Xj5")
        components?.queryItems = [APIKey]
        
        guard let finalURL = components?.url else {return completion(.failure(.invalidURL))}
        
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            do {
                let photoData = try JSONDecoder().decode([EarthImage].self, from: data)
                print("here is the photo data \(photoData.first?.caption)")
                let earthImage = photoData.first
                completion(.success(earthImage ?? EarthImage(image: "", date: "", caption: "")))
                
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
   static func formatDatePathComponent(earthImage: EarthImage) -> String {
       
        guard let date = earthImage.date else {return ""}
        
        let index = date.index(date.startIndex, offsetBy: 4)
        let year = date[..<index]
        let yearString = String(year)

        let monthStart = date.index(date.startIndex, offsetBy: 5)
        let monthEnd = date.index(date.endIndex, offsetBy: -12)
        let monthRange = monthStart..<monthEnd
        let month = date[monthRange]
        let monthString = String(month)

        let dayStart = date.index(date.startIndex, offsetBy: 8)
        let dayEnd = date.index(date.endIndex, offsetBy: -9)
        let dayRange = dayStart..<dayEnd
        let day = date[dayRange]
        let dayString = String(day)
        
        return "\(yearString)/\(monthString)/\(dayString)/png"
    }
    
    static func fetchImage (earthImage: EarthImage, completion: @escaping (Result<UIImage, EarthImageError>) -> Void) {
        //https://epic.gsfc.nasa.gov/archive/natural/2021/05/04/png/epic_1b_20210504003634.png
        let datePathComponent = formatDatePathComponent(earthImage: earthImage)
        let imagePathComponent = "\(earthImage.image ?? "").png"
        
        guard let buildImageURL = baseImageURL?.appendingPathComponent(datePathComponent) else {return completion(.failure(.invalidURL))}
        let finalURL = buildImageURL.appendingPathComponent(imagePathComponent)
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(.thrownError(error)))
            }
            guard let data = data else {return completion(.failure(.noData))}
            
            guard let image = UIImage(data: data) else {return completion(.failure(.noData))}
            completion(.success(image))
        }.resume()
    }
}//End of Class


