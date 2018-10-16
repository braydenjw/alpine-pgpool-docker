# alpine-pgpool2-docker
A Dockerfile and supporting configs and scripts for running Pgpool on an Alpine Linux container.

Environment variables are used to generate the corresponding config files:

- /usr/share/pgpool2/pcp.conf.gucci
- /usr/share/pgpool2/pgpool.conf.gucci
- /usr/share/pgpool2/pool_hba.conf.gucci

## Usage
```bash
$ docker run -d --name pgpool2 \
         -e PGPOOL_BACKENDS=pg1:5432:5,pg2:5432:5,pg3:5432:5 \
         --expose 5432 \
         --expose 9898 \
         braydenjw/alpine-pgpool2-docker
```

## Environment Variables
### Run-time
```
ENV PCP_PORT 9898
ENV PCP_USERNAME postgres
ENV PCP_PASSWORD postgres
ENV PGPOOL_PORT 5432
ENV PGPOOL_BACKENDS postgres:5432:10
ENV TRUST_NETWORK 0.0.0.0/0
ENV PG_USERNAME postgres
ENV PG_PASSWORD postgres

ENV NUM_INIT_CHILDREN 32
ENV MAX_POOL 4
ENV CHILD_LIFE_TIME 300
ENV CHILD_MAX_CONNECTIONS 0
ENV CONNECTION_LIFE_TIME 0
ENV CLIENT_IDLE_LIMIT 0
```
### Build-time
```
ENV PGPOOL_VERSION 3.7.5
ENV PG_VERSION 10.5-r0
```
