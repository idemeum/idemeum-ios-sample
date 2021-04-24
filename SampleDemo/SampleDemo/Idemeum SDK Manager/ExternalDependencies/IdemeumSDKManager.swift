import UIKit

public class IdemeumSDKManager {
    var idemeumGateway = IdemeumConfigurator.shared.idemeumGateWay()
    
    func loginToIdemeum(viewController:UIViewController, loginType: LoginType,onCompletion : @escaping (_ isSuccess: Bool, _ reason: String, _ response: Dictionary<String, Any>) -> Void) {
        idemeumGateway.loginToIdemeumSDK(viewController: viewController, loginType: loginType, onComplete: onCompletion)
    }
}
