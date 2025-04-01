//
//  FastLocalizeManager.swift
//  FastLocalize
//
//  Created by pan on 2025/4/1.
//

import Foundation

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
