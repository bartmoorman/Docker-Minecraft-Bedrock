### Docker Run
```
docker run \
--detach \
--name minecraft-bedrock \
--restart unless-stopped \
--publish 19132:19132/udp \
--volume minecraft-bedrock-config:/config \
--volume minecraft-bedrock-data:/data \
bmoorman/minecraft-bedrock:latest
```

### Docker Compose
```
version: "3.7"
services:
  minecraft-bedrock:
    image: bmoorman/minecraft-bedrock:latest
    container_name: minecraft-bedrock
    restart: unless-stopped
    ports:
      - "19132:19132/udp"
    volumes:
      - minecraft-bedrock-config:/config
      - minecraft-bedrock-data:/data

volumes:
  minecraft-bedrock-config:
  minecraft-bedrock-data:
```

### Environment Variables
|Variable|Description|Default|
|--------|-----------|-------|
|TZ|Sets the timezone|`America/Denver`|

All options in `server.properties` can be updated using environment variables with:
```
MC_<Key>
```
Everything should be uppercase, `.` and `-` should be replaced by `_`. For example, if you want to update these settings:
```
server-name=My Bedrock Server
allow-list=true
level-name=Season01
```
You would set the following environment variables:
```
MC_SERVER_NAME=My Bedrock Server
MC_ALLOW_LIST=true
MC_LEVEL_NAME=Season01
```
