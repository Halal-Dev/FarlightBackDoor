# Farlight BackDoor

Reversing Farlight84 Lua System

## How does this work?

The game Farlight84 makes an HTTPS request to retrieve a LUA code from several hosts, namely:

```backdoor.slfps.com```
```backdoor.farlight84miraclegames.com```

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

## Disclaimer

We vehemently discourage any form of cheating and hacking, including the exploitation of vulnerabilities like our backdoor in Farlight84. We cannot be held responsible for any actions taken by individuals to compromise the integrity of the game or violate its terms of service. Such activities not only undermine the fairness of gameplay but also pose serious legal and ethical implications. We advocate for fair play and urge users to refrain from engaging in any unauthorized access or manipulation of game systems. Any misuse of our tools or encouragement of unethical behavior is contrary to our principles and values.
