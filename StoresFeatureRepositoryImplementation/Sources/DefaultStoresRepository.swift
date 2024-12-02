import Foundation

import StoresFeatureEntity
import StoresFeatureRepository

public class DefaultStoresRepository: StoresRepository {
  
  private let session: URLSession
  private let decoder: JSONDecoder
  
  public init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
    self.session = session
    self.decoder = decoder
  }
  
  public func getStores(latitude: Double, longitude: Double) async throws -> [StoreEntity] {
    var components = URLComponents(string: "https://uljukah.kro.kr/stores/")
    components?.queryItems = [
      URLQueryItem(name: "latitude", value: "\(latitude)"),
      URLQueryItem(name: "longitude", value: "\(longitude)")
    ]
    
    guard let url = components?.url else {
      throw APIError.invalidURL(url: components?.url?.absoluteString)
    }
    
    do {
      let (data, response) = try await session.data(from: url)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw APIError.unknownError
      }
      
      switch httpResponse.statusCode {
      case 200:
        do {
          return try decoder.decode([StoreEntity].self, from: data)
        } catch {
          throw APIError.decodingError(error)
        }
      default:
        throw APIError.invalidResponse(statusCode: httpResponse.statusCode)
      }
    } catch {
      throw APIError.networkError(error)
    }
  }
}
