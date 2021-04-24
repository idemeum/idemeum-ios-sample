

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnIdemeumAppLogin: UIButton!
    @IBOutlet weak var btnBioMetricLogin: UIButton!
    @IBOutlet weak var buttonIdemeumLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleIdemeumButton()
    }
    
    //Description: This method will do corner radius for idemeum button
    func styleIdemeumButton(){
        buttonIdemeumLogin.layer.cornerRadius = 10
        btnBioMetricLogin.layer.cornerRadius = 10
        btnIdemeumAppLogin.layer.cornerRadius = 10
    }
    
    //Description: This method is responsible for login into the idemeum SDK with Idemeum App
    @IBAction func loginWithIdemeumApp(_ sender: Any) {
        self.idemeumSignIn(loginType: .ViaApp)
    }
    
    //Description: This method is responsible for login into the idemeum SDK with BioMetric
    @IBAction func loginWithBioMetric(_ sender: Any) {
        self.idemeumSignIn(loginType: .BioMetric)
    }
    
    //Description: This method is responsible for login into the idemeum SDK with Single Sign in
    @IBAction func loginWithSigningleSign(_ sender: Any) {
        self.idemeumSignIn(loginType: .SingleSignIn)
    }
}

extension LoginViewController {
    func idemeumSignIn(loginType: LoginType) {
        IdemeumSDKManager().loginToIdemeum(viewController: self, loginType: loginType, onCompletion: { (isLoginSuccess: Bool, reason: String, response: Dictionary<String, Any>) in
            if(isLoginSuccess) {
                var email = ""
                var familyname = ""
                var jti = ""
                var aud = ""
                var given_name = ""
                var sub = ""
                if let emailResponse = response["email"] as? String{
                    email = emailResponse
                }
                if let familyNameResponse = response["family_name"] as? String{
                    familyname = familyNameResponse
                }
                if let jtiResponse = response["jti"] as? String{
                    jti = jtiResponse
                }
                if let audResponse = response["aud"] as? String{
                    aud = audResponse
                }
                if let given_nameResponse = response["given_name"] as? String{
                    given_name = given_nameResponse
                }
                if let subResponse = response["sub"] as? String{
                    sub = subResponse
                }
                DispatchQueue.main.async {
                    let profileController = self.storyboard?.instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController
                    profileController?.user =  User(family_name: familyname, jti: jti, aud: aud, email: email, given_name: given_name, sub: sub)
                    self.navigationController?.pushViewController(profileController!, animated: true)
                }
            }else{
                print(isLoginSuccess)
            }
        })
    }
}
