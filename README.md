# Todos

Tasks api server

## Main resources

- users (signup, signin via [jwt](https://jwt.io/))
- projects (create, update, delete)
- tasks (create, update, delete, priority, deadline)
- comments (create, delete, attach images)

## Running

The Postgres docker image is used for development.

```bash
docker compose build
docker compose up/down
```

Setup database and run the server.

```bash
bundle install
bin/rails db:setup
bin/rails server
```

To run application in the Docker container uncomment `services -> web` section and edit database host value.

```bash
docker compose up
docker compose exec web bin/rails db:setup
docker compose exec web bin/rails server
```

## Client app

See other repository [page](https://github.com/mstranger/todos-client).  

Address for requests - `https://todos-server-atmu.onrender.com`  
Note that the first one may take a long time.

## Docs

To view api documentation follow [this](https://app.swaggerhub.com/apis/MSTRANGER/todos-api/1.0.0) link
or [this](https://todos-server-atmu.onrender.com/apipie).  
