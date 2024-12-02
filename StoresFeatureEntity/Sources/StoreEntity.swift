import Foundation

public struct StoreEntity: Decodable {
  public let id: String
  public let name: String
  public let address: String
  public let zipCode: String
  public let latitude: Double
  public let longitude: Double
  public let distance: Double
  public let americano: MenuItem
  public let menuItems: [MenuItem]
  
  public struct MenuItem: Decodable {
    public let name: String
    public let price: Int
    
    public init(name: String, price: Int) {
      self.name = name
      self.price = price
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case id, name, address, latitude, longitude, distance, americano
    case zipCode = "zip_code"
    case menuItems = "menu_items"
  }
  
  fileprivate init(
    id: String,
    name: String,
    address: String,
    zipCode: String,
    latitude: Double,
    longitude: Double,
    distance: Double,
    americano: MenuItem,
    menuItems: [MenuItem]
  ) {
    self.id = id
    self.name = name
    self.americano = americano
    self.menuItems = menuItems
    self.address = address
    self.zipCode = zipCode
    self.latitude = latitude
    self.longitude = longitude
    self.distance = distance
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    address = try container.decode(String.self, forKey: .address)
    zipCode = try container.decode(String.self, forKey: .zipCode)
    latitude = try container.decode(Double.self, forKey: .latitude)
    longitude = try container.decode(Double.self, forKey: .longitude)
    distance = try container.decode(Double.self, forKey: .distance)
    americano = try container.decode(MenuItem.self, forKey: .americano)
    menuItems = try container.decode([MenuItem].self, forKey: .menuItems)
  }
}

public enum StoreEntityFixture {
  public static func create(
    id: Int = 1,
    name: String = "TEST 카페",
    latitude: Double = 37.5156,
    longitude: Double = 127.111,
    distance: Double = 11,
    americano: StoreEntity.MenuItem = .init(name: "아메리카노 ice", price: 3000),
    menuitems: [StoreEntity.MenuItem] = [
      .init(name: "아메리카노 ice", price: 3000),
      .init(name: "아메리카노 ice", price: 3000),
      .init(name: "아메리카노 ice", price: 3000)
    ]
  ) -> StoreEntity {
    .init(
      id: "Test \(id)",
      name: name,
      address: "송파구 방이동 123123",
      zipCode: "123123",
      latitude: latitude,
      longitude: longitude,
      distance: distance,
      americano: americano,
      menuItems: menuitems
    )
  }
  
  public static func createBulk(count: Int) -> [StoreEntity] {
    (0 ..< count).map { create(id: $0) }
  }
}
