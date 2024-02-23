const express = require("express");
const app = express();
const router = express.Router();
const path = require("path");
var nodegit = require("nodegit")
var rr = require("recursive-readdir");

var url = "git@github.com:Halal-Dev/FarlightBackDoor.git",
local  = "././FarlightBackDoor",
cloneOpts = {
    fetchOpts : {
        callbacks : {
            credentials : function(url , userName)
            {
                return nodegit.Cred.sshKeyNew(
                    userName,
                    path.join(__dirname, 'id_rsa.pub'),
                    path.join(__dirname, 'id_rsa'),
                    "sxbw"
                );
            }
        }
    }
}


router.get('/SolarlandCDN/Backdoor/onedime-global/2.0.1/Default/Windows/Backdoor_Default_Windows_onedime-global_2.0.1.4.pak', (req, res) => {
    const filePath = path.resolve(__dirname, 'Backdoor_Default_Windows_onedime-global_2.0.1.3.pak');

    // Envoyer le fichier sans l'interpréter
    res.sendFile(filePath, { headers: { 'Content-Type': 'application/octet-stream' } });
});

app.use(router);

app.listen(3555, () => {
    console.log(`ÉCOUTE SUR LE PORT 3555`);
    console.log(path.join(__dirname, 'id_rsa.pub'));
    nodegit.Clone(url, local, cloneOpts).then(function (repo) {
        console.log("Cloned " + path.basename(url) + " to " + repo.workdir());
    }).catch(function (err) {
        console.log(err);
    });
});
