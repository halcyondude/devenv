# https://grafana.com/docs/loki/latest/installation/docker

# wget https://raw.githubusercontent.com/grafana/loki/v2.4.2/cmd/loki/loki-local-config.yaml -O loki-config.yaml
# wget https://raw.githubusercontent.com/grafana/loki/v2.4.2/clients/cmd/promtail/promtail-docker-config.yaml -O promtail-config.yaml

docker run --name loki -v $(pwd):/mnt/config -p 3100:3100 grafana/loki:2.4.2 -config.file=/mnt/config/loki-config.yaml

docker run -v $(pwd):/mnt/config -v /var/log:/var/log --link loki grafana/promtail:2.4.2 -config.file=/mnt/config/promtail-config.yaml



wget https://raw.githubusercontent.com/grafana/loki/v2.4.2/production/docker-compose.yaml -O docker-compose.yaml
docker-compose -f docker-compose.yaml up