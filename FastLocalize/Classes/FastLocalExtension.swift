//
//  FastLocalExtension.swift
//  FastLocalize
//
//  Created by pan zhang on 2024/11/10.
//

import Foundation

// App常用词语
public enum FastLocalWord: String, CaseIterable {
    case Confirm = "Confirm"
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


public extension Bundle {
    static func localizeMainResourceUrl(name: String, ext:String) -> URL? {
        let code = FastLocalizeManager.shared.language.languageCode
        var path = Bundle.main.url(forResource: name, withExtension: ext, subdirectory: nil, localization: code)
        if path == nil {
            // 这里可以自动识别系统语言？
            path = Bundle.main.url(
                forResource: name,
                withExtension: ext,
                subdirectory: nil,
                localization: "en") ?? Bundle.main.url(forResource: "privacy", withExtension: "html")
        }
        return path
    }
}
