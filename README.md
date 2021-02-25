### Amplify Storage Sample

These steps provision storage with authentication. Authentication uses HostedUI.

1. `amplify init`
2. `amplify add storage`
```
? Please select from one of the below mentioned services: `Content (Images, audio, video, etc.)`
? You need to add auth (Amazon Cognito) to your project in order to add storage for user files. Do you want to add auth now? `Yes`
 Do you want to use the default authentication and security configuration? `Default configuration with Social Provider (Federation)`
 How do you want users to be able to sign in? `Username`
 Do you want to configure advanced settings? `No, I am done.`
 What domain name prefix do you want to use? `<default>`
 Enter your redirect signin URI: `myapp://`
? Do you want to add another redirect signin URI `No`
 Enter your redirect signout URI: `myapp://`
? Do you want to add another redirect signout URI `No`
 Select the social providers you want to configure for your user pool: `<selected none>`
Successfully added auth resource amplifystoragesample60006e81 locally

? Please provide a friendly name for your resource that will be used to label this category in the project: `<default>`
? Please provide bucket name: `<default>`
? Who should have access: `Auth and guest users`
? What kind of access do you want for Authenticated users? `create/update, read, delete`
? What kind of access do you want for Guest users? `create/update, read, delete`
? Do you want to add a Lambda Trigger for your S3 Bucket? `No`
Auth configuration is required to allow unauthenticated users, but it is not configured properly.
Successfully updated auth resource locally.
Successfully added resource s35ecf6065 locally
```
3. `amplify push`
```
Hosted UI Endpoint: https://amplifystoragesample-dev.auth.us-west-2.amazoncognito.com/
Test Your Hosted UI Endpoint: https://amplifystoragesample-dev.auth.us-west-2.amazoncognito.com/login?response_type=code&client_id=123&redirect_uri=myapp://
```

4. `pod install --repo-update`

5. `xed .`

6. Build and run the app



