import Foundation

public enum APIError: Error {
  case invalidURL(url: String?)
  case invalidResponse(statusCode: Int)
  case decodingError(Error)
  case networkError(Error)
  case unknownError
}

extension APIError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .invalidURL:
      return "Invalid URL."
    case .invalidResponse(let statusCode):
      return "Invalid response from the server. Status code: \(statusCode)"
    case .decodingError(let error):
      return "Failed to decode the response: \(error.localizedDescription)"
    case .networkError(let error):
      return "Network error occurred: \(error.localizedDescription)"
    case .unknownError:
      return "Unknown error occurred."
    }
  }
}
