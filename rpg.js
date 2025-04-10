const fs = require('fs');
const path = require('path');
const dbPath = path.join(__dirname, '..', 'database.json');
const db = JSON.parse(fs.readFileSync(dbPath));

module.exports = {
  nome: "gold",
  async executar(client, msg, args) {
    const user = msg.from;

    if (!db[user]) db[user] = { gold: 0 };
    const action = args[0];

    if (action === "trabalhar") {
      const ganho = Math.floor(Math.random() * 50) + 10;
      db[user].gold += ganho;
      fs.writeFileSync(dbPath, JSON.stringify(db, null, 2));
      msg.reply(`💰 Você trabalhou e ganhou *${ganho}* gold!\nTotal: ${db[user].gold} gold.`);
    } else {
      msg.reply(`💸 Seu saldo atual: *${db[user].gold || 0}* gold.\nUse: /gold trabalhar`);
    }
  }
}
