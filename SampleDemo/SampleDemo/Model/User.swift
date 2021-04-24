import UIKit

class User: NSObject {
    var family_name:String = ""
    var jti: String = ""
    var aud: String = ""
    var email: String = ""
    var given_name: String = ""
    var sub: String = ""
    
    init(family_name: String, jti: String, aud: String, email: String, given_name: String, sub: String) {
        self.family_name = family_name
        self.jti = jti
        self.aud = aud
        self.email = email
        self.given_name = given_name
        self.sub = sub
    }
}
