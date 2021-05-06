
# Integration overview

Similar to our other SDKs, idemeum iOS SDK provides 4 methods to help you with your login needs: login, logout, userClaims, isLoggedIn. By leveraging these methods you can enable passwordless, secure, and private login for your mobile application.

##### What we will do

In this guide we will go through the following steps to implement idemeum iOS SDK:

- Initialize idemeum SDK
- Manage authentication state with isLoggedIn
- Log the user in and out with login and logout
- Get and validate user claims with userClaims

##### 1. Initialize idemeum SDK
We will be using Cocoapods for our project. Here is what we will add to our Podfile:

`pod 'idemeum’`

And then we will run pod install.

Now, we can import and initialize the IdemeumManager instance of idemeum SDK.


    import idemeum
    
    struct IdemeumKeys {
        //replace your clientID with the one you obtained from developer portal
        static var SingleSign = "ClientId"
        static var BioMetricKey = "ClientId"
        static var DVMIKey = "Clientid"
    }
    
    let idemeumSDK = Idemeum(parentView: UIViewController(), clientId: "")


##### 2. Manage authentication state with isLoggedIn
idemeum SDK helps you manage the authentication state of the user, so that you can determine if the user is logged in or not and then take actions depending on the outcome. With idemeum isLoggedIn we can obtain Boolean value for idemeum authentication state.

If the user is logged in, we will greet the user and display user claims.
In case the user is not logged in, we will not show any content and will simply display the login button.

    func isLoggedIn() {
        idemeumSDK.isLoggedIn(completionHandler: { isLoggedIn in
            // Process the user logged-in state.
            if(isLoggedIn) {
              // Display user claims if the user is logged in
                self.getUserClaims()
            } else {
               // Display the login button if the user is NOT logged in
            }
        })
##### 3. Log the user in and out with login and logout¶
When the user clicks the Login button, idemeum SDK will trigger the login method. Let's define what will need to happen in our application. On success our application will receive ID and Access tokens from idemeum. We will need to process and validate those tokens. In case there is failure, we can process that as well in our code.


    func idemeumSignIn(loginType: LoginType) {idemeumSDK=Idemeum(parentView:self,clientId:LoginMedium(type:loginType).key)
            idemeumSDK.login { (isSuccess, idemeumSigninResponse, error) in
                if(isSuccess) {
                    // Get User Claims.
                    self.getUserClaims()
                } else {
                   // If there is an error you can process it here
                    self.displayAlert(msg: error?.errorMessage ?? "Error occured.Pls tryagain")
                }
            }
        }
When the user clicks the Logout button, idemeum SDK will trigger the logout method.

`idemeumSDK.logout()`

##### 4. Get and validate user claims with userClaims
idemeum SDK returns ID and Access tokens upon successful user login. For token validation you can:

Validate token yourself using any of the open source JWT token validation libraries
Use idemeum SDK that provides userClaims method to validate tokens
In our guide we will rely on idemeum SDKs to validate tokens and extract user identity claims.


    func getUserClaims(){
            idemeumSDK.userClaims { (isSuccess, response, error) in
                if isSuccess {
                    if let response = response as? String {
                        let responseDict = self.convertStringToDictionary(text: response as String)
                 //user claims will be received as JSONObject here
                        self.onUserResponseReceived(response: responseDict!)
                    }
                } else {
                    //failed to get user claims
                    self.displayAlert(msg: error?.errorMessage ?? "Error occured..Pls try again")
                }
            }
        }

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
                let profileController = self.storyboard?.instantiateViewController(identifier:"ProfileViewController") as? ProfileViewController
                profileController?.user =  User(family_name: familyname, jti: jti, aud: aud, email: email, given_name: given_name, sub: sub)           self.navigationController?.pushViewController(profileController!,animated:true)
            }
        }

