#!/usr/bin/zsh

export JAVA_HOME=/home/iyunbo/.jdks/corretto-15.0.2
export PATH=$PATH:/home/iyunbo/tools/node-v14.11.0-linux-x64/bin
export VAULT_ADDR="https://192.168.1.22:31000/"
export VAULT_SKIP_VERIFY=1
export FUNCTIONS_CORE_TOOLS_TELEMETRY_OPTOUT=true

function stopall(){
  docker stop $(docker ps -aq)
}

function rmall(){
  docker rm $(docker ps -aq)
}

function mi(){
  ssh iyunbo@192.168.3.19
}

function clean_docker(){
 docker system prune -a
}

function boot_perf(){
 systemd-analyze critical-chain
}

function perf_blame(){
 systemd-analyze blame
}

function wifiinfo(){
 set -x
 iw dev wlp2s0 link
 sudo lshw -C network
}

function buildmi(){
  mvn clean install -DskipTests -PskipJs,skipStyle
}

function yunbo(){
 vault kv get keepass/iyunbo | grep -i ${1}
}

function fin(){
 vault kv get keepass/finance | grep -i ${1}
}

function docker_nas(){
 export DOCKER_HOST=tcp://192.168.1.22:2376 DOCKER_TLS_VERIFY=1
 echo "docker points to $DOCKER_HOST"
}

function docker_mi(){
 export DOCKER_HOST=tcp://192.168.3.19:2375
 unset DOCKER_TLS_VERIFY
 echo "docker points to $DOCKER_HOST"
}

function setup_vault(){
 complete -C /home/iyunbo/.local/bin/vault vault
}

docker_mi
setup_vault
