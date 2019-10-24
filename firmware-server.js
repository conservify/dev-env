const path = require('path');
const express = require("express");
const fs = require('fs');
const app = express();

const port = 6060;
const home = process.env.HOME;
const local = path.join(home, "fieldkit/dev-env/archive/local");
const archived = "archive/fk-firmware-266";
const serving = local;

function applicationFirmware(req, res) {
    const name = "fk-bundled-fkb.bin";
    fs.realpath(path.join(serving, name), (err, real) => {
        if (err) {
            console.log('error', err);
            return;
        }
        console.log(req.connection.remoteAddress, real, req.params);
        res.sendFile(real);
    });
}

function bootloaderFirmware(req, res) {
    const name = "fkbl-fkb.bin";
    fs.realpath(path.join(serving, name), (err, real) => {
        if (err) {
            console.log('error', err);
            return;
        }
        console.log(req.connection.remoteAddress, real, req.params);
        res.sendFile(real);
    });
}

app.get("/:deviceId/fk-bundled-fkb.bin", applicationFirmware);
app.get("/:deviceId/fkbl-fkb.bin", bootloaderFirmware);

app.get("/fk-bundled-fkb.bin", applicationFirmware);
app.get("/fkbl-fkb.bin", bootloaderFirmware);

app.get("*", (req, res, n) => {
    res.status(404).send("404 not found");
});

app.listen(port, () => {
    console.log("Listening on :" + port);
    console.log("Serving", serving)
});
