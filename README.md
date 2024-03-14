# htmx
Trying out how it would be to use htmx with gleam.

- Web-stuff with Wisp/Mist
- Templating with Nakai

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
watchexec -r -e gleam -E DEVELOPMENT=true -- gleam run </dev/null # Watch and run
```

## Build
```sh
docker build -t htmx-gleam .
docker run --rm -it -p 8000:8000 htmx-gleam
```