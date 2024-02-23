const express = require("express");
const app = express();
const router = express.Router();
const path = require("path");

router.get('/SolarlandCDN/Backdoor/onedime-global/2.0.1/Default/Windows/Backdoor_Default_Windows_onedime-global_2.0.1.4.pak', (req, res) => {
    const filePath = path.resolve(__dirname, 'Backdoor_Default_Windows_onedime-global_2.0.1.3.pak');

    // Envoyer le fichier sans l'interpréter
    res.sendFile(filePath, { headers: { 'Content-Type': 'application/octet-stream' } });
});

app.use(router);

app.listen(3555, () => {
    console.log(`ÉCOUTE SUR LE PORT 3555`);
});
