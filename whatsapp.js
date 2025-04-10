const makeWASocket = require("@whiskeysockets/baileys").default;
const { useSingleFileAuthState } = require("@whiskeysockets/baileys");
const { default: P } = require("pino");
const { Boom } = require('@hapi/boom');
const fs = require('fs');
const path = require('path');
const config = require('./config');

// Carrega os comandos
const comandos = {};
fs.readdirSync('./scripts').forEach(function(file) {
  const comando = require('./scripts/' + file);
  comandos[comando.nome] = comando;
});

const authFile = './session.json';
const auth = useSingleFileAuthState(authFile);
const state = auth.state;
const saveState = auth.saveState;

async function iniciarBot() {
  const sock = makeWASocket({
    printQRInTerminal: true,
    auth: state,
    logger: P({ level: "silent" })
  });

  sock.ev.on("creds.update", saveState);

  sock.ev.on("messages.upsert", async function(update) {
    const messages = update.messages;
    if (!messages || !messages[0] || !messages[0].message) return;

    const msg = messages[0];
    const texto = msg.message.conversation || 
                  (msg.message.extendedTextMessage && msg.message.extendedTextMessage.text) || "";
    const sender = msg.key.remoteJid;

    if (!texto.startsWith(config.prefixo)) return;

    const args = texto.slice(config.prefixo.length).trim().split(/ +/);
    const nomeComando = args.shift().toLowerCase();

    const comando = comandos[nomeComando];
    if (!comando) return;

    comando.executar(sock, {
      from: sender,
      body: texto,
      reply: function(txt) {
        sock.sendMessage(sender, { text: txt });
      }
    }, args);
  });
}

iniciarBot();
