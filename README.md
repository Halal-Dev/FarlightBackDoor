# Farlight BackDoor

Reversing Farlight84 Lua System

## How does this work?

The game Farlight84 makes an HTTPS request to retrieve a LUA code from several hosts, namely:

backdoor.slfps.com
backdoor.farlight84miraclegames.com
We intercept this request through Fiddler Classic and host (locally, for now) an ExpressJS server that will return a highly sophisticated backdoor.

## How to test it?

1. Clone the repository,
2. Place your id_rsa and id_rsa.pub files, which are authorized to access the repository, into ExpressServer Folder.
3. Navigate to the directory containing the repository in the terminal:
```cd ExpressServer```
4. Once done, execute:
```npm i```
5. and finally:
```npm start```
Once done, the server will download the latest highly sophisticated backdoor and will host a web server.

6. After download and install: [Fiddler Classic](https://telerik-fiddler.s3.amazonaws.com/fiddler/FiddlerSetup.exe)

7. Install Fiddler Certificates in Tools > Options > HTTPS and activate "Decrypt HTTPS Traffic" option.

8. Paste the content of ```FiddlerScript.txt``` into Fiddler Classic's Fiddler Script category and click ```Save Script```.

9. Tip: Change All Processes to Non-Browsers for better readability.