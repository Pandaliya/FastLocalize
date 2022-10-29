// FastLocalize.swift
//

var FastLocalizeBundle: Bundle? = nil
public extension String {
    class FastLocalize {}
    var fastLocalized:String {
        if FastLocalizeBundle == nil {
            var path = Bundle.main.url(forResource: "Frameworks", withExtension: nil)
            path = path?.appendingPathComponent("FastLocalize")
            path = path?.appendingPathExtension("framework")
            if let p = path {
                let framework = Bundle.init(url: p)
                let bundlePath = framework?.url(forResource: "FastLocalize", withExtension: "bundle")
                if let bp = bundlePath {
                    FastLocalizeBundle = Bundle.init(url: bp)
                }
            }
        }
        
        guard let fl = FastLocalizeBundle else {
            return self
        }
        
        return fl.localizedString(forKey: self, value: "", table: nil)
    }
}




