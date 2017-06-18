# Snapshots
**Snapshots** is an iOS application that enables a user to capture 10 snapshots in 5 seconds and save them locally on the device.

## Platform
iOS, Swift 3, XCode 8.3.3

## How to build
- Open the project workspace in XCode 8 and build (Command+B) tha app to make sure there are no warnings and errors.
- Run (Command+R) the app on a device and a launch screen is displayed and expect it to redirect to the home screen which has a button **Open Camera**
- When you click on the button, after asking for user permissions, the front camera is opened and records for 6 seconds and goes back to the home screen
- Check for the message on the home screen **Snapshots captured**, indicating that the snapshot images are saved locally in the app documents directory with names "snapshot0.png" to "snapshot9.png"

## Further Considerations
- I have used a cocoapod KeychainAccess for securely saving the image data with the filenames as the keys.
- I would love to study about NSFileProtectionComplete class that I found to be most secure way of saving files and would try to work with it.

## Cloning the Project

Get started by cloning the project to your local machine: https://github.com/akashungarala/Snapshots
