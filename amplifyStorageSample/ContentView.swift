//
//  ContentView.swift
//  storageSample
//
//  Created by Law, Michael on 2/4/21.
//

import SwiftUI
import Amplify

struct ContentView: View {
    @EnvironmentObject var authService: AuthService
    func uploadToGuestPublic() {
        let dataString = "Example file contents"
        let data = dataString.data(using: .utf8)!
        Amplify.Storage.uploadData(key: "ExampleKey", data: data,
            progressListener: { progress in
                print("Progress: \(progress)")
            }, resultListener: { (event) in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        })
    }
    
    func uploadToGuestProtected() {
        let dataString = "My Data"
        let data = dataString.data(using: .utf8)!
        let options = StorageUploadDataRequest.Options(accessLevel: .protected)
        Amplify.Storage.uploadData(key: "ExampleKey", data: data, options: options) { result in
            switch result {
            case .success(let data):
                print("Completed: \(data)")
            case .failure(let storageError):
                print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        }
    }
    
    func uploadTo(_ accessLevel: StorageAccessLevel) {
        let dataString = "Example file contents"
        let data = dataString.data(using: .utf8)!
        Amplify.Storage.uploadData(key: "ExampleKey", data: data, options: .init(accessLevel: accessLevel), progressListener: { progress in
            print("Progress: \(progress)")
        }, resultListener: { (event) in
                switch event {
                case .success(let data):
                    print("Completed: \(data)")
                case .failure(let storageError):
                    print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
            }
        })
    }

    var body: some View {
        VStack {
            if authService.isSignedIn {
                Button("sign out") {
                    authService.signOut()
                }
            } else {
                Button("signIn") {
                    authService.webSignIn()
                }
            }
            Button("upload to private", action: {
                uploadTo(.private)
            })
            Button("upload to protected", action: {
                uploadTo(.protected)
            })
            Button("print identity id") {
                print(authService.identityId)
            }
            Button("upload to public guest", action: {
                uploadToGuestPublic()
            })
            
            Button("upload to protected guest should fail", action: {
                uploadToGuestProtected()
            })
            
            Button("download from target", action: {
                
                let options = StorageDownloadDataRequest.Options(accessLevel: .protected,
                                                                 targetIdentityId: "us-west-2:480e1da6-04f6-447f-bf84-00dd1287db4f")
                
                Amplify.Storage.downloadData(
                    key: "ExampleKey",
                    options: options,
                    progressListener: { progress in
                        print("Progress: \(progress)")
                    }, resultListener: { (event) in
                        switch event {
                        case let .success(data):
                            print("Completed: \(data)")
                        case let .failure(storageError):
                            print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                    }
                })
            })
            
            Button("download for self", action: {
                
                let options = StorageDownloadDataRequest.Options(accessLevel: .protected)
                
                Amplify.Storage.downloadData(
                    key: "ExampleKey",
                    options: options,
                    progressListener: { progress in
                        print("Progress: \(progress)")
                    }, resultListener: { (event) in
                        switch event {
                        case let .success(data):
                            print("Completed: \(data)")
                        case let .failure(storageError):
                            print("Failed: \(storageError.errorDescription). \(storageError.recoverySuggestion)")
                    }
                })
            })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
