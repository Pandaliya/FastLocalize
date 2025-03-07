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


open class FastLocalizeManager {
    public static let UserDefaultsKey: String = "fast_localize_language_key"
    public static var shared: FastLocalizeManager = {
        let sha = FastLocalizeManager()
        return sha
    }()
    
    private init() {
        if let typeRaw = UserDefaults.standard.string(forKey: FastLocalizeManager.UserDefaultsKey), let type = FastLanguage.init(rawValue: typeRaw) {
            self.switchLanguage(type, sync: false)
        } else {
            self.currentLanguageBundle = FastLocalizeManager.FastLocalizeBundle
            self.mainLanguageBundle = Bundle.main
            self.language = .sys
        }
    }
    
    public private(set) var currentLanguageBundle: Bundle?
    public private(set) var mainLanguageBundle: Bundle?
    public private(set) var language: FastLanguage = .sys
    
    // MARK: - public
    public func switchLanguage(_ lang: FastLanguage = .sys, sync: Bool = true) {
        self.currentLanguageBundle = lang.bundle
        self.mainLanguageBundle = lang.languageBundle(of: Bundle.main) ?? Bundle.main
        self.language = lang
        NotificationCenter.default.post(name: .FastLanguageUpdate, object: nil)
        if sync {
            UserDefaults.standard.set(lang.rawValue, forKey: FastLocalizeManager.UserDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    // MARK: - lazy
    public static var FastLocalizeBundle: Bundle {
        var path = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
        path = path?.appendingPathComponent("FastLocalize")
        path = path?.appendingPathExtension("framework")
        if let p = path {
            let framework = Bundle.init(url: p)
            let bundlePath = framework?.url(forResource: "FastLocalize", withExtension: "bundle")
            if let bp = bundlePath, let bm = Bundle.init(url: bp){
                return bm
            }
        }
        return Bundle.main
    }
}

extension FastLocalizeManager: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

public extension String {
    class FastLocalize {}
    var fastLocalized:String {
        return FastLocalizeManager.shared.currentLanguageBundle?.localizedString(forKey: self, value: "", table: nil) ?? self
    }
    
    var mainLocalized:String {
        return FastLocalizeManager.shared.mainLanguageBundle?.localizedString(forKey: self, value: "", table: nil) ?? self
    }
    
    func localized(langage: FastLanguage = .sys) -> String {
        return langage.bundle?.localizedString(forKey: self, value: "", table: nil) ?? self
    }
}
