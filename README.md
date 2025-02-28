<div style="text-align: center;">
  <img src="/images/Amazon_Web_Services-Logo.wine.png" alt="Logo AWS" width="50%">
</div>

# AWS e Linux - Configuração de Servidor Web com Monitoramento

## Objetivo

Nesse projeto você irá desenvolver um ambiente de servidor web monitorado, utilizando **AWS**, **Linux (Amazon Linux)** e **Nginx**. Além da configuração do servidor, será implementado um sistema de monitoramento automatizado, com a **geração de logs e notificações em tempo real** via **Discord**.

**✏️** O passo a passo foi separado em etapas para melhor entendimento e compreensão do projeto.

## Tecnologias utilizadas 
- [Recursos da AWS](https://aws.amazon.com/pt/free/?gclid=CjwKCAiAt4C-BhBcEiwA8Kp0CXjynKQ_YB-lWNZxkkgTxELyHDMsGvJ6QwNfJrmvmk3v_BJbP5Q-nBoCd84QAvD_BwE&trk=2ee11bb2-bc40-4546-9852-2c4ad8e8f646&sc_channel=ps&ef_id=CjwKCAiAt4C-BhBcEiwA8Kp0CXjynKQ_YB-lWNZxkkgTxELyHDMsGvJ6QwNfJrmvmk3v_BJbP5Q-nBoCd84QAvD_BwE:G:s&s_kwcid=AL!4422!3!561843094929!e!!g!!aws!15278604629!130587771740&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all)
- [Discord Webhook](https://support.discord.com/hc/pt-br/articles/228383668-Usando-Webhooks)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Nginx](https://nginx.org/)
- [Git](https://git-scm.com/downloads)

## Pré-requisitos

- Criar uma conta na AWS (Confira os [tipos de ofertas da AWS](https://aws.amazon.com/pt/free/?gclid=CjwKCAiAiOa9BhBqEiwABCdG8xlyYVFUTUW4_1hqD1vbhSiF39OfbpYMA3HAzuYfrCGXDkgFgF-icRoCy_YQAvD_BwE&trk=2ee11bb2-bc40-4546-9852-2c4ad8e8f646&sc_channel=ps&ef_id=CjwKCAiAiOa9BhBqEiwABCdG8xlyYVFUTUW4_1hqD1vbhSiF39OfbpYMA3HAzuYfrCGXDkgFgF-icRoCy_YQAvD_BwE:G:s&s_kwcid=AL!4422!3!696214219374!e!!g!!aws!15278604629!130587771740&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsf.Free%20Tier%20Categories=*all))
- Ter uma conta no Discord
- Baixar o Visual Studio Code

<aside>

## Atenção

- A maioria dos comandos para criação de arquivos/pastas, instalação e verificação do serviço nginx exigiram o uso do `sudo` !
- Após alguns minutos de inatividade, a instância se desconecta. Basta apenas inserir a chave ssh novamente, mas cuidado para não perder as configurações realizadas
</aside>

# ⚙️ Configuração do Ambiente

## Criação da VPC

Antes de iniciar a instância, será necessária a criação da **VPC** (Virtual Private Cloud), que se trata de **uma rede virtual isolada** que permite executar recursos da AWS. Para isso:

1. Realize o cadastro na Amazon AWS; entre no Console de gerenciamento da AWS
    1. Selecione a região de United States - N. Virginia, que foi escolhida para o projeto. Para mais informações sobre as regiões e suas zonas de disponibilidade [clique aqui](https://docs.aws.amazon.com/pt_br/awsconsolehelpdocs/latest/gsg/select-region.html)
2. Clique na barra de pesquisa e digite ‘VPC’

<img src="/images/image.png">

1. Na seção de **Virtual private cloud**, selecione **Your VPCs**. Logo em seguida, clique em **Create VPC**
    1. Em VPC settings, selecione **VPC and more**, para pré-visualizar as subnets públicas e privadas, a tabela de rotas  e conexão de redes
    2. Dê um nome para a VPC
    3. Não altere mais nenhuma configuração padrão, navegue para baixo e clique em **Create VPC**

<img src="/images/image 1.png">

- Após a criação da VPC, as subnets, subnets públicas e privadas, a tabela de rotas e a conexão de rede, são criadas automaticamente

## Criação de uma instância EC2 na AWS

O Amazon Elastic Compute Cloud (Amazon EC2) oferece uma capacidade de computação escalável sob demanda na Nuvem Amazon Web Services (AWS).

⚠️ Antes da criação da EC2, será necessário criar um **Security Group** para a instância

1. Entre no Console de gerenciamento da AWS
2. Clique na barra de pesquisa e digite EC2
3. Em seguida, vá para **Security Groups** e clique em **Create Security Group**
    1. Na seção **Basic Details**, dê um nome para seu security group, uma descrição e selecione a VPC que acabou de criar
        
        <img src="/images/image 2.png">
        
    2. Logo depois, na seção **Inbound rules**, será feita as regras de entrada da instância
        1. Crie duas regras de inbound em **Add rule**
        2. Em **Type**, na primeira regra, selecione **HTTP**. Para a segunda, selecione **SSH**
        3. Em **Source**,  na primeira regra, selecione Anywhere-IPv4. Para a segunda, selecione My IP
        4. Adicione uma descrição para ambas as regras
    
    <img src="/images/image 3.png">
    
    1. Logo depois, na seção **Outbound rules**, será feita as regras de saída da instância
        1. Crie uma regra de Outbound em Add Rule
        2. Em **Type**, selecione All trafic
        3. Em **Destination**, selecione Anywhere-IPv4
    
    <img src="/images/image 4.png">
    

Agora, será possível criar a instância EC2!

1. Entre no Console de gerenciamento da AWS → Clique na barra de pesquisa e digite EC2
2. Vá em **Instances** e clique em **Launch an instance**
    1. Crie uma tag e dê um nome a sua instância
    2. Em seguida, vá para **Application and OS Images (Amazon Machine Image)** selecione a AMI da Amazon Linux 2023
        
        <img src="/images/image 5.png">
        
    3. Abaixo, em **Instance Type** e selecione **t2.micro** (disponível no Free Tier)
    4. Em **Key Pair (Login**), selecione **Create new key pair** ao lado e cria a chave para a instância. Dê um nome, escolha RSA para **Key pair type** e escolha o **Private key file format** para **.pem** para ser usada com o OpenSSH
        
        <img src="/images/image 6.png">
        
    5. Em **Network settings**, clique em Edit e faça as seguintes configurações:
        1. Na seção **VPC**, selecione a VPC que acabou de criar
        2. Em seguida, na seção **Subnet**, selecione uma subnet pública (de preferência, a da zona de disponibilidade us-east-1a
        3. Em **Auto-assign public IP**, selecione **Enable**
            
            <img src="/images/image 7.png">
            
        4. Logo depois em **Firewall (security groups),** clique em **Select existing security group** e selecione o security group criado anteriormente
    6. Depois de todas as configurações necessárias, role para baixo e clique em **Launch Instance.** Após carregar, clique em **view all instances** e espere alguns minutos para que a EC2 esteja com o **Status check** igual ao da imagem abaixo:
        
        <img src="/images/image 8.png">
        

## Acessando a instância via SSH

O computador local pode ter um cliente SSH instalado por padrão. Você pode verificar isso ao inserir o comando a seguir em uma janela de terminal. Se o computador não reconhecer o comando, instale um cliente SSH.

Como a AMI do projeto é baseada em Linux, as futuras configurações de conexão e servidor serão realizadas pelo terminal do Git Bash do Visual Studio Code

1. Por padrão, o terminal do VS Code é o Windows PowerShell. Para trocar para Git Bash, abra o VS Code, vá nas três barrinhas no canto superior esquerdo → clique em Terminal (ou aperte Crtl + J)
2. No lado superior direito do terminal, há o tipo de terminal que está utilizando e algumas configurações. Clique na setinha para baixo e selecione **Git Bash**

<img src="/images/image 9.png">

1. Logo depois, volte para o console da AWS → vá em **Instances →** selecione a instância que criou anteriormente e clique em Connect
2. Em **Connect to instance** vá para **SSH Client.** Aqui contém dois comando importantes para conectar a instância via SSH no VS Code
    
    <img src="/images/image 10.png">
    
3. No terminal do Git Bash, execute o comando com as alterações das permissões da chave da instância no tópico 3. e logo depois, o comando em Example abaixo
    
    <img src="/images/image 11.png">
    

# 🌐 Configuração do Servidor Web

## Instalação do Nginx

O **Nginx** (pronunciado “engine ex”) **é um software para servidor web de código aberto** conhecido por seu alto desempenho e baixo uso de recursos. Será utilizado para possibilitar o acesso da nossa instância pelo navegador.

1. No Amazon Linux 2023, execute o comando `sudo dnf install nginx -y` para realizar a instalação.
    1. `sudo systemctl start nginx` para iniciar o serviço
        
        <img src="/images/image 12.png">
        
    2. `sudo systemctl enable nginx` para iniciar automaticamente na inicialização do sistema
        
        <img src="/images/image 13.png">
        
    3.  `sudo systemctl status nginx` para ver status e `sudo systemctl restart nginx` para reiniciar o ngnix
    
2. Para ver a página padrão do Nginx, é preciso pegar o IP público da instância e jogá-la no barra de pesquisa do navegador, sucedido por `http://`. O IP público é localizado quando a instância é selecionada. Abaixo, mostra os detalhes da EC2
    
    <img src="/images/image 14.png">
    

1. Selecionado o IP, está será a página default no Nginx

<img src="/images/image 15.png">

## Criar uma página HTML para ser exibida no navegador

Antes da personalização do nosso site (da página default do Nginx), precisamos alterar algumas configurações no arquivo de configuração do Ngnix

1. Vá até o diretório `/etc/nginx/` e crie uma cópia do arquivo `ngnix.conf`

```bash
 sudo cp nginx.conf nginx.conf.original
```

1. Execute o comando `sudo nano /etc/nginx/nginx.conf`cd / e faça as alterações (O código está no arquivo ngnix.conf)

<aside>
📌

A linha include /etc/nginx/conf.d/serverbru.conf corresponde ao caminho do arquivo da configuração do site

</aside>

1. Navegue até o diretório `/etc/nginx/conf.d/` e crie o arquivo de configuração do site `serverbru.conf` (O código está no arquivo serverbru.conf)
2. Em seguida, vá ao diretório `/var` e crie uma pasta chamada `www` → `sudo mkidr www`
3. Dentro da pasta `www` , crie a pasta que ficará o conteúdo da página do servidor web (Neste caso, o nome da pasta é sitebruna.com)
    
    <img src="/images/image 16.png">
    
4. Dentro da pasta sitebruna.com, crie um arquivo html. Logo após crie uma pasta chamada `css` , onde ficará o estilo da página, e nela crie um arquivo css (Os códigos estão nos arquivos index.html e na pasta css)
5. Reinicie o Nginx executando `sudo systemctl restart nginx`

<img src="/images/image 17.png">

# 🔔 Monitoramento e Notificações

Nesta etapa, será realizado:

- A criação do serviço systemd para garantir que o Ngnix reinicie automaticamente caso parar
- Criar um script em Bash para monitorar a disponibilidade do site e mandar notificações via Discord

## Criação do script

1. Antes da criação do script, será necessário criar dois arquivos de log: um para o monitoramento e outro para as requisições
    1. Vá até o diretório `/var/log` e crie dois arquivos: `requisicoes.log` e `monitoramento.log` . O primerio armazena o conteúdo da resposta HTTP recebida do endereço IP da sua máquina e o segundo registra o histórico das verificações de status do servidor
        
        ```bash
        sudo touch requisicoes.log monitoramento.log
        ```
        
2. Navegue até o diretório `/usr/bin/` e crie um arquivo chamado `monitoramento.sh`. Nele estará o script de monitoramento em Bash (O código está disponível em monitoramento.sh)
    1. Na variável `webhoook` , insira a url do seu webhook do Discord. [Clique aqui](https://www.alura.com.br/artigos/webhooks?srsltid=AfmBOorKb3Z7HXhrjjGNkf2VZiElJ7RNG6T8XYcPo4FQL43CgX0-sYOC) para mais detalhes de como criar um webhook no Discord
3. Se o sistema não estiver configurado no horário do Brasil, execute `timedatectl` para verificar e `sudo timedatectl set-timezone America/Sao_Paulo` para alterar para o nosso fuso horário. Assim, data e horário aparecerão corretos nas notificações do Discord
4. Após a criação do `monitoramento.sh`, será preciso alterar as permissões para que o mesmo seja executado → execute `sudo chmod a+x monitoramento.sh` (`a+x` adiciona a permissão de execução para todos os usuários)
    
    <img src="/images/image 18.png">
    

## Configuração do Systemd

1. Navegue até o diretório `/etc/systemd/system/` e crie um arquivo com o nome de `monitoramento.service` (O código está presente em monitoramento.service)
2. Como foi feito com monitoramento.sh, `execute sudo chmod a+x monitoramento.service` para mudar as permissões do arquivo
3. Atualize todos os serviços do Nginx com `sudo systemctl daemon-reload` e inicie o monitoramento.sh com `sudo systemctl start monitoramento.service` . Após inicar o serviço de monitoramento, aparecerá os alertas no Discord no canal que criou para o webhook

   <img src="/images/image 19.png">

## Teste a Implementação

Execute o comando `sudo systemctl stop nginx` . Automaticamente, aparecerá uma mensagem no seu webhook do Discord, notificando que o servidor está fora do ar. Após 30 segundos, graças ao systemd, o Nginx reiniciará e o site voltará normalmente

  <img src="/images/image 20.png">
  <img src="/images/image 21.png">

# ✨ Conclusão 

A principal função desse projeto foi consolidar os meus conhecimentos sobre AWS e Linux. As soluções implementadas, como a configuração do Nginx e a criação do script de monitoramento, resultaram em um sistema funcional, eficiente e automatizado. As dificuldades encontradas durante a implementação foram cruciais para o meu aprendizado em Cloud Computing e DevSecOps.
