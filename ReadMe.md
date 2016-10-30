### Why Use This?
You have an HTML email signature template for your Mail.app users (maybe something like [this sample template](http://seesolve.com/words/wp-content/uploads/2013/06/html_sig.html)). You need to incorporate the user's contact information into the template. This script automates that process, requesting the user's information, replacing your template's placeholders with the user's information, and importing the signature into Mail.app.

### Requirements
Mac OS X 10.7.x - 10.8.x.

The script requires an active internet connection, GUI scripting (script will attempt to enable), and that your HTML email signature template is accessible online.

### Installation
It's a script; installation is not required. You can [download the zip file](https://github.com/seesolve/CreateHtmlEmailSignature/archive/master.zip) and extract the script. Opening the script file will open AppleScript Editor and you will be able to run the script. You can also copy the raw text of CreateHtmlEmailSignature.scpt and paste it into an empty AppleScript Editor window to save the script on your computer.

### Help
The best way to request help is to post a new [issue](https://github.com/seesolve/CreateHtmlEmailSignature/issues/).

### Issues
Report problems on the [issue tracking page](https://github.com/seesolve/CreateHtmlEmailSignature/issues). Following are some current issues to be aware of. 

#### iCloud
After the signature is imported into Mail.app, [the signature disappears](https://github.com/seesolve/CreateHtmlEmailSignature/issues/1). This appers to be caused by iCloud's documents and data syncing preferences and is being worked on.

#### Mavericks, Yosemite, El Capitan, and Sierra (Mac OS 10.9, 10.10, 10.11, and 10.12)
The script was created using Lion (10.7) and tested on Mountain Lion (10.8). I don't have a computer with later versions to test or update the script. If you're running one of those versions and would like to help update the script, please [leave a comment](https://github.com/seesolve/CreateHtmlEmailSignature/issues/4).

#### Can’t set UI elements enabled of application to true
This is an issue with Mavericks and later versions (10.9+). [The process for enabling GUI scripting has changed](https://support.apple.com/en-us/HT202802).

### Contributing
Contributions welcome. Currently seekers testers for Mac OS X versions 10.9+. See [Contributing](https://github.com/seesolve/CreateHtmlEmailSignature/blob/master/Contributing.md) for more info.

### License
Read the [license](https://github.com/seesolve/CreateHtmlEmailSignature/blob/master/License.txt).
