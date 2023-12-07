# flipt-demo

Quick demo of [flipt](https://www.flipt.io/) feature flags for fooling around.

It starts a single `flipt` server which is scraped by prometheus. The server uses a simple sqlite database.  A go app connects to the server
using [openfeature](https://openfeature.dev/), then reads a single flag value and prints the result. The [app](./app/main.go) can be edited
to choose between GRPC and HTTP transports, and to edit the request context – i.e. the targetingKey and attributes.

The flags config in [flags.yml](./flags.yml) demonstrates usage of segments and progressive rollout:

- anyone whose favourite colour is green will have the flag enabled
- everyone else is subject to progressive rollout, this uses the targeting key to partition – an individual key will see consistent flag value

## Usage

The server is started by

```plaintext
make start
```

Flags can be imported:

```plaintext
make import
```

Run the [client app](./app/main.go) to read flags:

```plaintext
make run
```

If you edit the flags through the [Web UI](http://127.0.0.1:8080), you can re-export the flags:

```plaintext
make export
```

Then stop everything once you're done:

```plaintext
make stop
```

Metrics:

- The Flipt prometheus metrics endpoint is [here](http://127.0.0.1:8080/metrics).
- The Prometheus UI is [here](http://127.0.0.1:9090), try loading this
  [example query](http://127.0.0.1:9090/graph?g0.expr=increase(flipt_evaluations_results_total%5B1m%5D)&g0.tab=0&g0.stacked=0&g0.show_exemplars=0&g0.range_input=5m)
  after you've run the app a few times.
