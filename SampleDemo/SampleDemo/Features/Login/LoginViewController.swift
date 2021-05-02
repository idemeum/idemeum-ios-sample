
import UIKit
import idemeum

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnIdemeumAppLogin: UIButton!
    @IBOutlet weak var btnBioMetricLogin: UIButton!
    @IBOutlet weak var buttonIdemeumLogin: UIButton!
    var idemeumSDK = Idemeum(parentView: UIViewController(), clientId: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonIdemeumLogin.layer.cornerRadius = 10
        btnBioMetricLogin.layer.cornerRadius = 10
        btnIdemeumAppLogin.layer.cornerRadius = 10
        
        isLoggedIn()
    }
    
    //Description: This method convert the received string encoded object to dictionary
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
    
    private func displayAlert(msg: String){
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
             let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
             })
             alert.addAction(cancel)
             DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
        })
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

    //Description: This method checks whether the user is logged in or not
extension LoginViewController {
    func isLoggedIn(){
        idemeumSDK.isLoggedIn(completionHandler: { isLoggedIn in
            if(isLoggedIn){
                self.getUserClaims()
            } else {
                // show login button
            }
        })
    }
    
    //Description: This method will do login
    func idemeumSignIn(loginType: LoginType) {
        idemeumSDK = Idemeum(parentView: self, clientId: LoginMedium(type: loginType).key)
        idemeumSDK.login { (isSuccess, idemeumSigninResponse, error) in
            if(isSuccess) {
                self.getUserClaims()
            } else {
                self.displayAlert(msg: error?.errorMessage ?? "Error occured..Pls try again")
            }
        }
    }
    
    //Description: This method will Get the user claims
    func getUserClaims(){
        idemeumSDK.userClaims { (isSuccess, response, error) in
            if isSuccess {
                if let response = response as? String {
                    let responseDict = self.convertStringToDictionary(text: response as String)
                    self.onUserResponseReceived(response: responseDict!)
                }
            } else {
                //failed to get user claims
                self.displayAlert(msg: error?.errorMessage ?? "Error occured..Pls try again")
            }
        }
    }
    
    //Description: Parse the user received data
    private func onUserResponseReceived( response: Dictionary<String, Any>){
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
    }
}


