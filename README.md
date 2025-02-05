# RainbowPoop

Rainbow Poop is a simple game where you control poop character that's going through the stomach until it is poop out of the body. You can eat food to improve your health and going out as fast as possible.

Note: The .txt files present in some folders are placeholder files that exist solely to allow pushing empty folders to GitHub. Git does not track empty folders by default, so these .txt files ensure the folder structure is maintained in the repository.

## Export to Android

Needs to have android sdk and java downloaded.
- Android (with Android studio) : https://developer.android.com/studio/install?hl=fr
- Java : https://www.java.com

Then, in godot, you need to go in `Editor -> Manage Export Template` and download it from the `Official Github Release`.
After that, you need to go in `Editor -> Editor Parameters -> General -> Export -> Android` and copy the the path for android sdk and java jdk (the one you downloaded just above).
Also, you need to execute as admin the following command inside the `jdk/bin` folder :
```cmd
keytool -genkey -v -keystore debug.keystore -storepass android -alias androiddebugkey -keypass android -keyalg RSA -keysize 2048 -validity 10000 -dname "C=US, O=Android, CN=Android Debug"
```

Then, still in `Editor -> Editor Parameters -> General -> Export -> Android`, you need to select the Debug Keystore that was created in the bin folder, with the command. (Don't change the user and password)
