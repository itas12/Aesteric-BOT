const fs = require('fs');
const path = require('path');
const config = require('./config');

// Simulação de estrutura simples de mensagens e comandos
const comandos = {};

// Carrega todos os comandos da pasta "scripts"
fs.readdirSync('./scripts').forEach(file => {
  const comando = require(`./scripts/${file}`);
  comandos[comando.nome] = comando;
});

// Simula o recebimento de uma mensagem (exemplo)
function receberMensagem(msg) {
  if (!msg.body.startsWith(config.prefixo)) return;

  const args = msg.body.slice(config.prefixo.length).trim().split(/ +/);
  const nomeComando = args.shift().toLowerCase();

  const comando = comandos[nomeComando];
  if (!comando) return console.log("Comando não encontrado.");

  // Verificação se o comando é só para admin e se é grupo
  if (config.adminOnly && comando.tipo !== 'admin') {
    return console.log("Somente admins podem usar comandos.");
  }

  comando.executar(null, msg, args);
}

// Exemplo de uso:
receberMensagem({ 
  from: "5588999999999", 
  body: "/gold trabalhar",
  reply: console.log 
});
