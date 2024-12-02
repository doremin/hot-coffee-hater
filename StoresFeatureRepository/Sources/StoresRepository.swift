import StoresFeatureEntity

public protocol StoresRepository {
  func getStores(latitude: Double, longitude: Double) async throws -> [StoreEntity]
}
