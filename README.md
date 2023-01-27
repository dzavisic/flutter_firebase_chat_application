# Flutter Chat application with Firebase

Flutter chat application with login and signup using Firebase.

## Short description

Signup form uses Firebase Email and Password authentication with Phone Number verification. <br><br>
Login form uses Firebase Email and Password authentication with Users stored in firestore database. <br><br>
Chat uses Firebase Realtime Database. <br><br>
User profile picture is stored in firebase storage.

## Setting up the project

1. Clone the repository.
2. Run the following command in the project directory: <br>
`flutter pub get`
3. You'll need to install <a href="https://firebase.google.com/docs/cli#setup_update_cli">Firebase CLI</a>.   
4. Log into Firebase using your Google account: <br>
`firebase login`
5. Install the FlutterFire CLI with command: <br>
`dart pub global activate flutterfire_cli`
6. Change your Firebase project plan to Blaze.
7. Run the following command: <br>
`flutterfire configure`
8. To deploy your functions to Firebase, run the following command: <br>
`cd firebase/functions && firebase deploy --only functions`
9. Update your Firestore rules to allow only authenticated users to access the database.
10. Update your Firebase Realtime Database rules to allow only authenticated users to access the database.
11. Finally, run the following command: <br>
`flutter run`

### Setup example of Realtime database structure for messaging
```
- chats 
 - chat_id
   - lastMessage: string
   - timestamp: number
   
- members
 - chat_id
    - user_id: true
    - user_id2: true
    
- messages
 - chat_id
    - message_id
       - message: string
       - timestamp: number
       - sender: user_id: string
```

## Screenshots

<div style="display: flex;">
<img src="https://user-images.githubusercontent.com/43092397/167423369-90d6161d-0fd5-48f2-ad93-2819088b75ea.png" width="190"/>
<img src="https://user-images.githubusercontent.com/43092397/167423355-ac950833-205a-4020-8a66-da60e80c3445.png" width="190"/>
<img src="https://user-images.githubusercontent.com/43092397/167423378-f519370e-ae49-41f2-b951-d0e995dea441.png" width="190"/>
<img src="https://user-images.githubusercontent.com/43092397/167423382-e271fea2-25e2-44fd-97c0-83c6728bfde4.png" width="190"/>
<img src="https://user-images.githubusercontent.com/43092397/167423384-84155ba4-23f8-48d2-bfc3-63ea887690ad.png" width="190"/>
</div>
