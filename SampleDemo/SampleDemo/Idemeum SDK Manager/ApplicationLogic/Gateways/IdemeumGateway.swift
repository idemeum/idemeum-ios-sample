import UIKit

protocol IdemeumGateway {
    func loginToIdemeumSDK(viewController: UIViewController,loginType: LoginType, onComplete:@escaping (_ isSuccess: Bool, _ reason: String, _ response: Dictionary<String, Any>) -> Void)
}
