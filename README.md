# README

## Rails Tutorials

### 使い方のメモ

起動と停止

```
$ docker-compose up -d
$ docker-compose stop
```

GemfileとDockerfileの変更時は、以下のコマンドで再ビルド

```
$ docker-compose build
```

railsコマンドを実行する

```
$ docker-compose run web [rails-command]
```

コンテナ内にアクセス

```
$ docker exec -it CONTAINER_ID bash
```

テストの実行

```
$ docker-compose
```

### ERROR対処
 * A server is already running. Check /myapp/tmp/pids/server.pid.が出たら
 　server.pidを削除して、もう一度docker-compose upをする
