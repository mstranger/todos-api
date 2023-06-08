# Todos

Tasks api server

## Main resources

- users (signup, signin via [jwt](https://jwt.io/))
- projects (create, update, delete)
- tasks (create, update, delete, priority, deadline)
- comments (create, delete, attach images)

## Running

The Postgres database is used through a Docker container. Edit db config file settings if it's not.

```bash
docker compose build
docker compose up/down
```

Then setup database and run the server:

```bash
bundle install
bin/rails db:setup
bin/rails server
```

To use Docker for entire application uncomment `services -> web` section in the compose file and uncomment host settings in the db config.

```bash
docker compose up
docker compose exec web bin/rails db:setup
docker compose exec web bin/rails server
```

## Client app

See [this](https://github.com/mstranger/todos-client) page.

## Docs

To view documentation in swagger format visit this [api](https://app.swaggerhub.com/apis/MSTRANGER/todos-api/1.0.0) link.  

Local address - [http://localhost:3000/apipie](http://localhost:3000/apipie).
