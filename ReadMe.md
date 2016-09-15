### Why Use This?
You have an HTML email signature template for your Mail.app users (maybe something like [this sample template](http://seesolve.com/words/wp-content/uploads/2013/06/html_sig.html)). You need to incorporate the user's contact information into the template. This script automates that process, requesting the user's information, replacing your template's placeholders with the user's information, and importing the signature into Mail.app.

### Requirements
Mac OS X 10.7.x - 10.8.x.

The script requires an active internet connection, GUI scripting (script will attempt to enable), and that your HTML email signature template is accessible online.

### Installation
It's a script; installation is not required. You can [download the zip file](https://github.com/seesolve/CreateHtmlEmailSignature/archive/master.zip) and extract the script. Opening the script file will open AppleScript Editor and you will be able to run the script. You can also copy the raw text of CreateHtmlEmailSignature.applescript and paste it into an empty AppleScript Editor window to save the script on your computer.

### Help
The best way to request help is to post a new [issue](https://github.com/seesolve/CreateHtmlEmailSignature/issues/).

### Issues
Report problems on the [issue tracking page](https://github.com/seesolve/CreateHtmlEmailSignature/issues). Following are some current issues to be aware of. 

#### iCloud
After the signature is imported into Mail.app, [the signature disappears](https://github.com/seesolve/CreateHtmlEmailSignature/issues/1). This appers to be caused by iCloud's documents and data syncing preferences and is being worked on.

#### Mavericks and Yosemite (OS X 10.9 and 10.10)
The script was created using Lion (10.7) and tested on Mountain Lion (10.8). I don't have a Mavericks or Yosemite computer to test or update the script for those versions. Please [report issues](https://github.com/seesolve/CreateHtmlEmailSignature/issues/2), and I'll help troubleshoot.

#### Can’t set UI elements enabled of application to true
This is an issue with Mavericks and probably Yosemite (10.9 and 10.10). [The process for enabling GUI scripting has changed](https://github.com/seesolve/CreateHtmlEmailSignature/issues/3). Looking into code signing the script in order for the script to run properly.

### Contributing
I am relatively new to GitHub and may not have immediate answers on how to navigate the platform. That said, if you want to help, please feel free to fork and send a pull request when you've fixed an issue. Use comments liberally. You can check the the existing script's comments for commenting style.

### License
Read the [license](https://github.com/seesolve/CreateHtmlEmailSignature/blob/master/License.txt).
