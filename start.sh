#!/bin/bash

# Função para exibir a mensagem com cor e estilo
echo_color() {
    local color=$1
    local message=$2
    case $color in
        "red") echo -e "\033[1;31m$message\033[0m" ;;    # Vermelho brilhante
        "green") echo -e "\033[1;32m$message\033[0m" ;;  # Verde brilhante
        "yellow") echo -e "\033[1;33m$message\033[0m" ;; # Amarelo brilhante
        "blue") echo -e "\033[1;34m$message\033[0m" ;;   # Azul brilhante
        "magenta") echo -e "\033[1;35m$message\033[0m" ;;# Magenta brilhante
        "cyan") echo -e "\033[1;36m$message\033[0m" ;;   # Ciano brilhante
        *) echo -e "$message" ;;
    esac
}

# Função para efeito de carregamento
loading_effect() {
    local message=${1:-"⏳ Carregando"}
    echo "$message"
    for i in {1..3}; do
        echo -n "."
        sleep 0.5
    done
    echo ""
}

# Função para verificar se a conexão já está ativa
verificar_conexao() {
    if [ -f "/path/to/conexao_ativa.txt" ]; then
        return 0  # Conectado
    else
        return 1  # Não conectado
    fi
}

# Função para conectar
conectar() {
    local tipo_conexao=$1
    local parametro=$2
    echo_color "blue" "🔄 TED V3.9 - Conexão via $tipo_conexao ativada..."
    loading_effect
    if [ "$tipo_conexao" == "QR Code" ]; then
        echo "Para conectar via QR Code, escaneie o código gerado com seu celular. Siga as instruções exibidas."
    else
        echo "Insira o código gerado no dispositivo para completar a conexão. Siga as instruções na tela."
    fi
    node connect.js "$parametro"
}

# Função para apagar arquivos dentro da pasta "tednexMart-qr"
apagar_qr() {
    local dir="./database/tednexMart-qr"
    if [ -d "$dir" ]; then
        rm -f "$dir"/*
        echo_color "green" "✅ Todos os arquivos dentro de '$dir' foram apagados com sucesso!"
    else
        echo_color "red" "❌ Diretório '$dir' não encontrado!"
    fi
}

# Loop para reiniciar automaticamente
while true; do
    # Banner com destaque (apenas se não estiver conectado)
    if ! verificar_conexao; then
        clear
        echo_color "magenta" "==============================="
        echo_color "yellow" "✨ Bem-vindo ao TED V3.9! ✨"
        echo_color "magenta" "==============================="
        echo ""
        echo "Este é o menu interativo para conectar-se ao TED de forma prática e divertida!"
        echo ""

        # Menu de opções
        echo_color "cyan" "🔽 Escolha uma opção abaixo (você tem 15 segundos para escolher):"
        echo_color "green" "1️⃣  Conectar via QR Code 🔗"
        echo_color "green" "2️⃣  Conectar via Código 🧾"
        echo_color "green" "3️⃣  Instalar Dependências 🛠️"
        echo_color "green" "4️⃣  Abrir Canal do YouTube 📺"
        echo_color "green" "6️⃣  Apagar arquivos do QR 🗑️"
        echo_color "red" "5️⃣  Sair 🚪"
        echo ""

        # Espera a entrada do usuário (15s)
        read -t 15 -p "Digite o número da opção: " opcao
        echo ""

        # Se não escolher nada, conecta automaticamente via QR Code
        if [ -z "$opcao" ]; then
            echo_color "yellow" "⏳ Tempo esgotado! Tentando conectar automaticamente..."
            conectar "QR Code" "não"
        else
            case $opcao in
                1)
                    conectar "QR Code" "não"
                    ;;
                2)
                    conectar "Código" "sim"
                    ;;
                3)
                    echo_color "green" "⚙️  Instalando dependências, aguarde..."
                    loading_effect "Preparando instalação"
                    apt-get update -y
                    apt-get upgrade -y
                    apt install -y nodejs nodejs-lts ffmpeg wget git
                    echo_color "green" "✅ Dependências instaladas com sucesso!"
                    echo "Execute 'sh start.sh' novamente e escolha a opção 1 ou 2 para se conectar."
                    ;;
                4)
                    echo_color "blue" "🌐 Abrindo canal do YouTube... 📺"
                    xdg-open "https://youtube.com/@ted_bot?si=bIQonBTdBUbaeHr2" 2>/dev/null
                    ;;
                6)
                    apagar_qr
                    ;;
                5)
                    echo_color "yellow" "👋 Obrigado por usar o TED V3.9! Até a próxima."
                    exit 0
                    ;;
                *)
                    echo_color "red" "❌ Opção inválida! Tente novamente."
                    echo "Escolha um número entre 1 e 6."
                    ;;
            esac
        fi
    else
        echo_color "green" "🔗 Conexão já está ativa! Iniciando a aplicação..."
        loading_effect
        node start.js  # Ajuste o comando para rodar o que for necessário
    fi

    # Caso o processo seja encerrado, reinicia o script após 5 segundos
    echo_color "red" "⚠️ O processo foi encerrado! Reiniciando em 5 segundos..."
    sleep 5
done