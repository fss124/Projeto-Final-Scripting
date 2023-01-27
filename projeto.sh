#!/bin/bash

## Script de Backup

# Este script cria um backup dos arquivos importantes na pasta home e faz upload para um servidor remoto.

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

#Compacta os arquivos importantes e salva na pasta de backup
tar -cvzf /workspaces/Projeto-Final-Scripting/backups/home_$(date +"%Y-%m-%d_%H-%M-%S").tar.gz /workspaces/Projeto-Final-Scripting/Documents /workspaces/Projeto-Final-Scripting/Pictures /workspaces/Projeto-Final-Scripting/Videos


#Define os limites de uso
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

#Pergunta ao usuário se deseja fazer upload do backup para um servidor remoto
read -p "Deseja fazer upload do backup para um servidor remoto? (s/n) " answer

#Verifica a resposta do usuário
if [ "$answer" == "s" ]; then
#Solicita as informações de login do servidor remoto
read -p "Informe o endereço do servidor: " server_address
read -p "Informe o nome de usuário: " username
read -p "Informe a senha: " -s password
echo ""

#Faz o upload do backup para o servidor remoto
scp /workspaces/Projeto-Final-Scripting/backups/home_$(date +"%Y-%m-%d_%H-%M-%S").tar.gz $username:$password@$server_address:/backups
echo "Upload concluído com sucesso!"
else
echo "Upload não realizado."
fi