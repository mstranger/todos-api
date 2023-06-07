# README

Tasks api server.

Main resources:

- users
- projects
- tasks
- comments

## Running

The postgresql database is used through a Docker container. Edit the db file settings if it's not.
So first you need to run this container.

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

Also you can use a Docker container for entire application. Uncomment `services -> web` section in the
compose file.

```bash
docker compose up
docker compose exec web bin/rails db:setup
docker compose exec web bin/rails server
```

## Client app

See [this](https://github.com/mstranger/todos-client) page.

## Docs

To view the documentation local visit [http://localhost:3000/apipie](localhost:3000/apipie).  
In swagger format: [https://app.swaggerhub.com/apis/MSTRANGER/todos-api/1.0.0](api).
