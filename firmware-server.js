const path = require('path');
const express = require("express");
const app = express();

const home = process.env.HOME;
const localBuild = path.join(home, "fieldkit/firmware/build/samd51/");

function applicationFirmware(req, res) {
    console.log(req.params);
    res.sendFile("fk/fk-bundled-fkb.bin", { root: localBuild });
}

function bootloaderFirmware(req, res) {
    console.log(req.params);
    res.sendFile("bootloader/fkbl-fkb.bin", { root: localBuild });
}

app.get("/:deviceId/fk-bundled-fkb.bin", applicationFirmware);
app.get("/:deviceId/fkbl-fkb.bin", bootloaderFirmware);

app.get("*", (req, res, n) => {
    res.status(404).send("404 not found");
});

app.listen(6060, () => {
    console.log("Listening on :6060");
});
