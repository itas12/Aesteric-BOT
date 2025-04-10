const config = require('../config');

module.exports = {
  nome: "nsfw",
  async executar(client, msg, args) {
    const comando = args[0];

    if (!msg.from.endsWith('@g.us')) {
      return msg.reply("⚠️ Use este comando apenas em grupos.");
    }

    if (comando === "on") {
      config.nsfwAtivado = true;
      msg.reply("🔞 Comandos NSFW foram *ativados* neste grupo.");
    } else if (comando === "off") {
      config.nsfwAtivado = false;
      msg.reply("❌ Comandos NSFW foram *desativados*.");
    } else {
      msg.reply("Use: /nsfw on ou /nsfw off");
    }
  },
  tipo: "admin"
}
