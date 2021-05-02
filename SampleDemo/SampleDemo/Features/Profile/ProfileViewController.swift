
import UIKit
import idemeum

class ProfileViewController: UIViewController {
    var user:User? = nil
    @IBOutlet weak var family_name: UILabel!
    @IBOutlet weak var given_name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Profile"
        family_name.text = "Family Name: \(String(describing: user!.family_name))"
        given_name.text = "Given Name: \(String(describing: user!.given_name))"
        email.text = "Email: \(String(describing: user!.email))"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
    }
    
    @objc private func logoutTapped(){
        let idemeumSDK = Idemeum(parentView: UIViewController(), clientId: "")
        idemeumSDK.logout()
        self.navigationController?.popViewController(animated: true)
    }
}

