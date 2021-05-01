import Foundation
import UIKit
import idemeum


class IdemeumGatewayImpl: IdemeumGateway {
    var idemeumSDK: Idemeum?
    
    func logoutUser() {
        self.idemeumSDK!.logout()
    }
    
    func isUserloggedIn(onComplete: @escaping (Bool, Dictionary<String, Any>)->Void){
        if idemeumSDK == nil{
            idemeumSDK = Idemeum(parentView: UIViewController(), clientId: "")
        }
        idemeumSDK!.isLoggedIn(completionHandler: { status in
            if(status == true){
                self.idemeumSDK!.userClaims { (isSuccess, response, error) in
                    if isSuccess {
                        if let response = response as? String {
                            let responseDict = self.convertStringToDictionary(text: response as! String)
                            onComplete(true, responseDict as! Dictionary<String, Any>)
                        }
                    } else {
                        onComplete(false, ["":""])
                    }
                }
            } else {
                onComplete(false, ["":""])
            }
        })
        
        self.idemeumSDK!.userClaims { (isSuccess, response, error) in
            if isSuccess {
            } else {
            }
        }
    }
    
    func loginToIdemeumSDK(viewController: UIViewController, loginType: LoginType, onComplete: @escaping (Bool, String, Dictionary<String, Any>) -> Void) {
        
        // This method is the main Idemeum Core SDK method. Where we will pass the parentviewcontroller and type of login.
        // Based upon the LoginType the 'LoginMedium' class will return the idemeum key
        idemeumSDK = Idemeum(parentView: viewController, clientId: LoginMedium(type: loginType).key)
        
        idemeumSDK!.login { (isSuccess, idemeumSigninResponse, error) in
            if(isSuccess) {
                if let token = idemeumSigninResponse?.token {
                    self.idemeumSDK!.userClaims { (isSuccess, response, error) in
                        if isSuccess {
                            if let response = response as? String {
                                let responseDict = self.convertStringToDictionary(text: response as! String)
                                onComplete(true, "", responseDict as! Dictionary<String, Any>)
                            }
                        } else {
                            onComplete(false, error?.statuscode.description ?? "", response as! Dictionary<String, Any>)
                        }
                    }
                }
            } else {
                onComplete(false, error?.statuscode.description ?? "", ["":""])
            }
        }
    }
    
    private  func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
}

