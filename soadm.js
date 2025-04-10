const config = require('../config');

module.exports = {
  nome: "soadm",
  async executar(client, msg, args) {
    const comando = args[0];

    if (!msg.from.endsWith('@g.us')) {
      return msg.reply("⚠️ Use este comando apenas em grupos.");
    }

    if (comando === "on") {
      config.adminOnly = true;
      msg.reply("✅ Agora apenas *admins* podem usar comandos.");
    } else if (comando === "off") {
      config.adminOnly = false;
      msg.reply("☑️ Todos no grupo podem usar comandos.");
    } else {
      msg.reply("Use: /soadm on ou /soadm off");
    }
  },
  tipo: "admin"
}
