import Foundation
import UIKit

class APIManager {
    static let shared = APIManager()
    
    private init() {}
    
    func fetchData(completion: @escaping (Result<Product, APIError>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/data/allFurniture") else {
            completion(.failure(APIError.connectionError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("1")
                completion(.failure(APIError.unexpectedError))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.failToFetchData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Furniture].self, from: data)
                let result = Product(furniture: decodedData)
                completion(.success(result))
            } catch {
                print("2")
                completion(.failure(APIError.unexpectedError))
            }
        }
        
        task.resume()
    }
    
    func findOne(id: String, completion: @escaping (Result<Furniture, APIError>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/data/allFurniture/\(id)") else {
            completion(.failure(APIError.connectionError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("1")
                completion(.failure(APIError.unexpectedError))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.failToFetchData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(Furniture.self, from: data)
                completion(.success(result))
            } catch {
                print("2")
                completion(.failure(APIError.unexpectedError))
            }
        }
        
        task.resume()
    }

    func getImage(imageName: String, completion: @escaping (Result<UIImage, APIError>) -> Void) {
        guard let url = URL(string: "http://localhost:3000/data/image/\(imageName).png") else {
            completion(.failure(APIError.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(APIError.connectionError))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(APIError.failToFetchData))
                return
            }
            
            completion(.success(image))
        }.resume()
    }

}

