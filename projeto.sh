#!/bin/bash

## Script de Backup

# Este script cria um backup dos arquivos importantes na pasta home e da base de dados, e faz upload para um servidor remoto.

# Verifica se a pasta de backup existe, caso contrário, cria-a
if [ ! -d /workspaces/Projeto-Final-Scripting/backups ]; then
    mkdir /workspaces/Projeto-Final-Scripting/backups
fi
if [ ! -d /workspaces/Projeto-Final-Scripting/Documents ]; then    
    mkdir /workspaces/Projeto-Final-Scripting/Documents
fi
if [ ! -d /workspaces/Projeto-Final-Scripting/Pictures ]; then
    mkdir /workspaces/Projeto-Final-Scripting/Pictures
fi
if [ ! -d /workspaces/Projeto-Final-Scripting/Videos ]; then
    mkdir /workspaces/Projeto-Final-Scripting/Videos
fi

# Cria a pasta de backup da base de dados
mkdir -p /workspaces/Projeto-Final-Scripting/backups/db

# Função para criar o backup da base de dados
backup_database() {
    # Gera o nome do arquivo de backup com a data atual
    data_atual=$(date +"%Y-%m-%d")
    nome_arquivo="areadetrabalho${data_atual}.sql"

    # Verifica se o arquivo de backup já existe na pasta de backup
    # Se existir, adiciona um contador ao nome do arquivo até que ele seja único
    i=1
    while [ -f "/workspaces/Projeto-Final-Scripting/backups/db/${nome_arquivo}" ]; do
        nome_arquivo="areadetrabalho${data_atual}${i}.sql"
        i=$((i + 1))
    done

    # Confirma se o usuário deseja realizar o backup da base de dados
    read -p "Deseja realizar o backup da base de dados? (s/n) " resposta

    if [ "$resposta" = "s" ]; then
        # Cria a cópia de segurança da base de dados e salva no arquivo gerado na pasta de backup
        mysqldump -u root -proot areadetrabalho > "/workspaces/Projeto-Final-Scripting/backups/db/${nome_arquivo}"

        echo "Cópia de segurança da base de dados salva como ${nome_arquivo} na pasta de backup"
    else
        echo "Backup da base de dados cancelado."
    fi
}

# Chama a função para fazer o backup da base de dados
backup_database

# Compacta os arquivos importantes e salva na pasta de backup
tar -cvzf /workspaces/Projeto-

#Define os limites de uso de cpu, memória e disco
cpu_threshold=80
memory_threshold=70
disk_threshold=90

#Obtém a data e hora atuais
date_time=$(date +"%Y-%m-%d %H:%M:%S")

#Obtém o uso de disco
disk_usage=$(df -h | awk 'NR==2{print $5}' | tr -d '%')

#Obtém o uso de memória
memory_usage=$(free -m | awk 'NR==2{print $3/$2 * 100.0}')

#Obtém o uso de CPU
cpu_usage=$(top -bn1 | awk '{print $9}' | tail -n+8 | awk '{s+=$1} END {print s}')

#Exibe as informações do estado do computador
echo "Data e Hora: $date_time"
echo "Uso de disco: $disk_usage"
echo "Uso de memória: $memory_usage%"
echo "Uso de CPU: $cpu_usage%"

#Verifica se os usos estão dentro dos limites
if [ $(echo "$cpu_usage > $cpu_threshold" | bc) -eq 1 ]; then
echo "ATENÇÃO: Uso de CPU está acima do limite"
else
echo "Uso de CPU está dentro do limite"
fi

if [ $(echo "$memory_usage > $memory_threshold" | bc) -eq 1 ]; then
echo "ATENÇÃO: Uso de memória está acima do limite"
else
echo "Uso de memória está dentro do limite"
fi

if [ $(echo "$disk_usage > $disk_threshold" | bc) -eq 1 ]; then
echo "ATENÇÃO: Uso de disco está acima do limite"
else
echo "Uso de disco está dentro do limite"
fi
