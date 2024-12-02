import SwiftUI

public enum ThemeMode: String, CaseIterable {
  case light
  case dark
  case system
}

public class ThemeManager: ObservableObject {
  
  private static let themeKey = "appTheme"
  
  @Published public var currentTheme: ThemeMode {
    didSet {
      UserDefaults.standard.setValue(currentTheme.rawValue, forKey: ThemeManager.themeKey)
    }
  }
  
  public init() {
    if let savedRawThemeValue = UserDefaults.standard.string(forKey: ThemeManager.themeKey),
       let theme = ThemeMode(rawValue: savedRawThemeValue) {
      currentTheme = theme
    } else {
      currentTheme = .system
    }
  }
}
