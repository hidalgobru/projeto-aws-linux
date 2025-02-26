#!/bin/bash

sudo curl --silent http://ip_da_maquina > /var/log/requisicoes.log

webhook="https://discord.com/api/webhooks/1342203545050415105/qTVPmtLsruwOGEF_by6WHL2rBfOwjVoQsg-o3bbSJeB7LlGhr6hcMtzHfWH9UgJwtBzT"

data=`sudo date +%d/%m/%Y" - "%H:%M:%S`

if sudo grep -q "Site" /var/log/requisicoes.log
then
        msg="$data :white_check_mark: Servidor escutando!"
        sudo echo $msg >> /var/log/monitoramento.log
else
        msg="$data :warning: Seu servidor está fora do ar!"
        sudo echo $msg >> /var/log/monitoramento.log
        sudo systemctl restart nginx.service
fi

sudo curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"$msg\"}" "$webhook"
