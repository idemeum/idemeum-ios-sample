import UIKit

protocol IdemeumGateway {
    func loginToIdemeumSDK(viewController: UIViewController,loginType: LoginType, onComplete:@escaping (_ isSuccess: Bool, _ reason: String, _ response: Dictionary<String, Any>) -> Void)
    func logoutUser()
    func isUserloggedIn(onComplete: @escaping (Bool, Dictionary<String, Any>)->Void)
}
