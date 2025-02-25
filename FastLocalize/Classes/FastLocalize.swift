// FastLocalize.swift
//

public var FLBundle: Bundle = FastLocalizeManager.shared.currentLanguageBundle

public enum FastLanguage: String, CaseIterable {
    case sys = "system"
    case en = "en" // 英语（无国别）
    case zh_hans = "zh-Hans" // 简体中文
    case zh_hant = "zh-Hant" // 繁体中文
    case ja = "ja" // 日文
    case ko = "ko" // 韩文
    
    var bundle: Bundle? {
        if self == .sys {
            return FastLocalizeManager.FastLocalizeBundle
        }
        
        if let path = FastLocalizeManager.FastLocalizeBundle.path(forResource: self.rawValue, ofType: "lproj") {
            return Bundle(path: path)
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
        }
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
            self.language = .sys
        }
    }
    
    public private(set) var currentLanguageBundle: Bundle!
    public private(set) var language: FastLanguage = .sys
    
    // MARK: - public
    public func switchLanguage(_ lang: FastLanguage = .sys, sync: Bool = true) {
        self.currentLanguageBundle = lang.bundle
        self.language = lang
        
        if sync {
            FLBundle = self.currentLanguageBundle
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
        return FLBundle.localizedString(forKey: self, value: "", table: nil)
    }
    
    func localized(langage: FastLanguage = .sys) -> String {
        return langage.bundle?.localizedString(forKey: self, value: "", table: nil) ?? self
    }
}




