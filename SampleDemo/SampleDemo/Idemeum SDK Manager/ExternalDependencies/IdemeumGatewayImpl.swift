import Foundation
import UIKit
import idemeum


class IdemeumGatewayImpl: IdemeumGateway {
    
    func loginToIdemeumSDK(viewController: UIViewController, loginType: LoginType, onComplete: @escaping (Bool, String, Dictionary<String, Any>) -> Void) {
        
        // This method is the main Idemeum Core SDK method. Where we will pass the parentviewcontroller and type of login.
        // Based upon the LoginType the 'LoginMedium' class will return the idemeum key
        Idemeum.shared.signin(parentView: viewController, clientId: LoginMedium(type: loginType).key) { (isSuccess, idemeumSigninResponse, reason) in
            if(isSuccess) {
                if let token = idemeumSigninResponse?.token {
                    Idemeum.shared.userClaims(oidcToken: token) { (isSuccess, response, item) in
                        onComplete(true, "", response as! Dictionary<String, Any>)
                    }
                }
            } else {
                onComplete(false, reason ?? "", ["":""])
            }
        }
    }
}

