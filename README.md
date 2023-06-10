# Todos

Tasks api server

## Main resources

- users (signup, signin via [jwt](https://jwt.io/))
- projects (create, update, delete)
- tasks (create, update, delete, priority, deadline)
- comments (create, delete, attach images)

## Running

The postgres docker image is used for development. Therefore, first check db config file settings and edit corresponding fields.

```bash
docker compose build
docker compose up/down
```

Setup database and run the server:

```bash
bundle install
bin/rails db:setup
bin/rails server
```

To run application in the Docker container uncomment `services -> web` section in the compose file and change host value to `db` in the config file.

```bash
docker compose up
docker compose exec web bin/rails db:setup
docker compose exec web bin/rails server
```

## Testing

To show code coverage, set the environment variable to `true`:

```bash
COVERAGE=true bin/rails test
```

## Client app

See [this](https://github.com/mstranger/todos-client) page.  
Address for requests - [https://todos-2tf6.onrender.com](https://todos-2tf6.onrender.com).

## Docs

To view api documentation visit [this](https://todos-server-atmu.onrender.com/apipie) link or [this](https://app.swaggerhub.com/apis/MSTRANGER/todos-api/1.0.0).  

Local address - [http://localhost:3000/apipie](http://localhost:3000/apipie).
