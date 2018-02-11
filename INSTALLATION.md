#  TV Gemist Installation Guide

Unfortunately the app cannot be distributed in the AppStore as the NPO does not allow third parties in doing so. However, using a free Apple Developer account you can compile it yourself and install it in your own Apple TV 4 (but also read the note below). While this may sound scary and difficult to non-technical users, it's really not that hard if you follow these steps :)

## Prerequisites:

- an Apple TV 4th or 5th generation (the ones that have an AppStore)
- run tvOS 10 or 11
- a recent Apple Computer running macOS 10.11.x El Capitan or higher
- a (free) Apple Developer account (signup here)

_Note: as of summer 2016 Apple has reduced the free Developer account provisioning from 90 days to a mere 7 days. This means when you are using a free Apple Developer Account the application will expire every 7 days after which you need to re-deploy the app (make sure to keep your bundle identifier the same for your favorites to stick). The premium Apple Developer Accounts do not have a time based limitation and deployed apps will continue to work during the lifetime of your subscription._

## 1. Xcode

Make sure you have [Xcode 9.2](https://itunes.apple.com/nl/app/xcode/id497799835) ([alternative link](https://developer.apple.com/download/more/)) installed. Continue with the following steps when you have finished installing ```Xcode``` as the next steps require a finished installation.

## 2. Download the project

You can either download a zipped distribution (novice) or use Git (advanced).

### 2.1 Download the zipfile

For novice users it is probably the easiest route to just download the [latest zipped version](https://github.com/4np/TVGemist/archive/master.zip) and continue with step 3. After installation to your Apple TV you are safe to delete the downloaded project but remember the _Bundle Identifier_ (see step 5) you used as you will need to use it again when you want to redeploy your app to your Apple TV (in the case of software updates or when your 7 day free developer limit runs out). 

### 2.2 Using Git

While not required, it is advisable to have a ```Developer``` folder on your machine. Execute the following code in ```Terminal``` to create those folders and clone this project:

```
mkdir -p ~/Developer/tvOS
cd ~/Developer/tvOS
git clone https://github.com/4np/TVGemist.git
cd TVGemist
```

If you are not experienced with Git, you can _pull_ new changes using:

```
cd ~/Developer/tvOS/TVGemist
git fetch
git pull
```

_Instead of using the terminal you can also use a graphical client like [SourceTree](https://www.sourcetreeapp.com), [Fork](https://git-fork.com) or [GitHub Desktop](https://desktop.github.com) (GitHub specific)._

## 3. Open the project

Now that everything is in place, you can open the project file ```TVGemist.xcworkspace``` (and _**not**_ the ```xcodeproj``` file)in ```Finder```. Alternatively, when you still have ```Terminal``` open you can also execute the following command:

```
open TVGemist.xcworkspace
```

## 4. Configure remote deploying (skip if already configured)

As of tvOS 11, Apple supports remote deploying to your Apple TV. While this is convenient, it is also a bit unstable as with every iOS update currently the link needs to be re-configured. 

### 4.1 On Apple TV

Navigate to `Settings > Remote controls and devices > Remote-app and devices`. 

### 4.2 In Xcode

Navigate to `Window > Devices and Simulators`. If your Apple TV is on the `Remote-app and devices` screen your Apple TV should be detected here in the left pane. Select the discovered Apple TV and click the button to pair your computer with your Apple TV. Enter the code you see on your Apple TV and Xcode will pair with your Apple TV. Wait for this process to finish before you continue to step 5.

![Apple TV Pairing](https://user-images.githubusercontent.com/1049693/36071838-6a72ad9e-0f15-11e8-8840-81bb0d05d188.png)

_When remote deploying **does not work anymore** (e.g. after os-updates for example) you need to remove and re-configure remote deployment. This means you need to remove your computer from the Apple TV settings (`Forget device`), and you need to remove your Apple TV from Xcode's `Devices and Simulators` screen by right-clicking on the Apple TV and selecting `Unpair Device`. Then re-pair the Apple TV by following the steps above. As an alternative you can also still use an USB-C cable to connect your Apple TV directly to your Mac and skip remote deploying altogether._

## 5. Change the Bundle Identifier

![Steps to perform](https://user-images.githubusercontent.com/1049693/36071674-bf6a3464-0f12-11e8-99de-e218f881898e.png)

The bundle identifier (see **3** in the screenshot above) uniquely identifies your app. As you cannot reuse mine, you need to set your own bundle identifier in reverse domain format (for example: com.yourname.TVGemist). Make sure you remember the name as you will need to enter the same bundle identifier when you want to update or re-deploy the app to your AppleTV.

_Note: using a different identifier will make the app deploy next to a previous installation and separate favorites. Keeping the identifier the same will make the favorites continue to work after updates. Also *free* Apple Developer Accounts have a limit on the number of different identifiers you can create on a weekly basis (10)._

## 6. Select the team

In order to deploy the application to the Apple TV it needs to be signed with your team (see **4** in the screenshot above). If you do not have a team (e.g. ```None```), or you see the message ```No Matching provisioning profiles found``` click the ```Fix Issue``` and login with your Apple ID / Apple Developer Account credentials.

## 7. Select the Build Device

On the top left in Xcode click on the device the compiled program will be deployed to (see **5** in the screenshot above). If your Apple TV is properly connected you will be able to pick you Apple TV device (otherwise it will run in the Simulator).

## 8. Run the application

Finally you are able to compile the program and deploy it onto your Apple TV! Click the play icon (see **6** in the screenshot above). The application will be compiled and deployed on your Apple TV. After this the application will remain on the Apple TV. 

_Note: if you encounter issues or you are unable to play, this is where you should debug what it going on. Observe the Xcode console output while leaving your Apple TV connected. Alternatively you can also run in the simulator (see **5** in the screenshot above) and observe the Xcode console output to debug the issues you are experiencing._

## 9. Sit back and enjoy :)

You're done! You can disconnect your Apple TV and start watching! :)

