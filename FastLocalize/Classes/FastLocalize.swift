// FastLocalize.swift
//

public extension Notification.Name {
    static let FastLanguageUpdate = Notification.Name("FastLanguageUpdate")
}

public enum FastLanguage: String, CaseIterable {
    case sys = "system"
    case en = "en" // 英语（无国别）
    case zh_hans = "zh-Hans" // 简体中文
    case zh_hant = "zh-Hant" // 繁体中文
    case ja = "ja" // 日文
    case ko = "ko" // 韩文
    case vi = "vi" // 越南语
    case ru = "ru" // 俄语
    
    var bundle: Bundle? {
        if self == .sys {
            return FastLocalizeManager.FastLocalizeBundle
        }
        
        if let path = FastLocalizeManager.FastLocalizeBundle.path(forResource: self.rawValue, ofType: "lproj") {
            return Bundle(path: path)
        }
        return nil
    }
    
    // 获取跟随系统时的语言代码
    public var languageCode: String {
        guard self == .sys else {
            return self.rawValue
        }
        if let preferredLanguage = Locale.preferredLanguages.first {
            var languageCode = preferredLanguage.components(separatedBy: "-")
            if languageCode.count > 1 {
                languageCode.removeLast()
            }
            return languageCode.joined(separator: "-")
        }
        return "Base"
    }
    
    public func languageBundle(of bundle: Bundle, subdirectory: String? = nil) -> Bundle? {
        guard self != .sys else {
            if let dir = subdirectory, let path = bundle.path(forResource: dir, ofType: nil) {
                return Bundle(path: path)
            }
            return bundle
        }
        
        if subdirectory == nil {
            if let path = bundle.path(forResource: self.rawValue, ofType: "lproj") {
                return Bundle(path: path)
            }
        } else {
            if let path = bundle.path(forResource: self.rawValue, ofType: "lproj", inDirectory: subdirectory) {
                return Bundle(path: path)
            }
        }
        return nil
    }
    
    public var localizedTitle: String {
        switch self {
        case .sys:
            return "Set with the system".fastLocalized
        case .en:
            return "English".fastLocalized
        case .zh_hans:
            return "Chinese".fastLocalized
        case .ja:
            return "Japanese".fastLocalized
        case .ko:
            return "Korean".fastLocalized
        case .zh_hant:
            return "Chinese Traditional".fastLocalized
        case .vi:
            return "Vietnamese".fastLocalized
        case .ru:
            return "Russian".fastLocalized
        }
    }
    
    public var title: String {
        switch self {
        case .sys:
            return "Set with the system".fastLocalized
        case .en:
            return "English"
        case .zh_hans:
            return "简体中文"
        case .zh_hant:
            return "繁體中文"
        case .ja:
            return "日本語"
        case .ko:
            return "한국인"
        case .ru:
            return "Русский"
        case .vi:
            return "Tiếng Việt"
        }
    }
    
    public static var systemCurrent: String? {
        return Locale.current.languageCode
    }
}

