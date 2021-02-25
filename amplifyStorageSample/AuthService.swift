//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import AmplifyPlugins
import AWSPluginsCore

class AuthService: ObservableObject {

    var isSignedIn: Bool {
        user != nil
    }
    @Published var user: AuthUser?
    @Published var hasError = false
    @Published var authError: AuthError?

    var identityId: String?
}

extension AuthService {

    func checkSessionStatus() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                // Get user sub or identity id
                do {
                    if let identityProvider = session as? AuthCognitoIdentityProvider {
                        let usersub = try identityProvider.getUserSub().get()
                        let identityId = try identityProvider.getIdentityId().get()
                        print("User sub - \(usersub) and identity id \(identityId)")
                        self.identityId = identityId
                    }
                    
                    // Get aws credentials
                    if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
                        let credentials = try awsCredentialsProvider.getAWSCredentials().get()
                        print("Access key - \(credentials.accessKey) ")
                    }
                    
                    // Get cognito user pool token
                    if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                        let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                        print("Id token - \(tokens.idToken) ")
                    }
                } catch {
                    print("Fetch auth session failed with error - \(error)")

                }
                
                
                DispatchQueue.main.async {
                    guard session.isSignedIn else {
                        self.user = nil
                        return
                    }

                    guard let user = Amplify.Auth.getCurrentUser() else {
                        self.user = nil
                        return
                    }

                    self.user = user
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.authError = error
                    self.hasError = true
                }
            }
        }
    }

    private var window: UIWindow {
        guard
            let scene = UIApplication.shared.connectedScenes.first,
            let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
            let window = windowSceneDelegate.window as? UIWindow
        else { return UIWindow() }

        return window
    }

    func webSignIn() {
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: window,
                                         options: .preferPrivateSession()) { result in
            switch result {
            case .success:
                self.checkSessionStatus()
            case .failure(let error):
                DispatchQueue.main.async {
                    if case .service(_, _, let underlyingError) = error,
                       case .userCancelled = (underlyingError as? AWSCognitoAuthError) {
                        return
                    } else {
                        self.authError = error
                        self.hasError = true
                    }
                }
            }
        }
    }

    func signOut() {
        _ = Amplify.Auth.signOut { result in
            switch result {
            case .success:
                self.checkSessionStatus()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.authError = error
                    self.hasError = true
                }
            }
        }
    }

    func observeAuthEvents() {
        _ = Amplify.Hub.listen(to: .auth) { result in
            switch result.eventName {
            case HubPayload.EventName.Auth.sessionExpired:
                self.checkSessionStatus()
            default:
                break
            }
        }
    }
}
