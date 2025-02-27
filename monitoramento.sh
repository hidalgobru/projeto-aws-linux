#!/bin/bash

sudo curl --silent localhost > /var/log/requisicoes.log

webhook="url_webhook"

data=`sudo date +%d/%m/%Y" - "%H:%M:%S`

if sudo grep -q "Servidor" /var/log/requisicoes.log
then
        msg="$data :white_check_mark: Servidor escutando!"
        sudo echo $msg >> /var/log/monitoramento.log
else
        msg="$data :warning: Seu servidor está fora do ar!"
        sudo echo $msg >> /var/log/monitoramento.log
        sudo systemctl restart nginx.service
fi

sudo curl -H "Content-Type: application/json" -X POST -d "{\"content\":\"$msg\"}" "$webhook"
