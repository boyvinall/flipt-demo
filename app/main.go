package main

import (
	"context"
	"log/slog"

	"github.com/open-feature/go-sdk/pkg/openfeature"
	"go.flipt.io/flipt-openfeature-provider/pkg/provider/flipt"
)

const (
	fliptGRPC = "localhost:9000"
	fliptHTTP = "http://localhost:8080"

	flagName = "v2_enabled"
)

func main() {
	openfeature.SetProvider(flipt.NewProvider(
		flipt.WithAddress(fliptGRPC),
	))

	client := openfeature.NewClient("my-app")

	slog.Info("getting flag")
	value, err := client.BooleanValue(context.Background(), flagName, false, openfeature.NewEvaluationContext(
		"bob@example.com", // targetingKey is used by progressive rollouts to ensure each user gets a consistent value
		map[string]interface{}{ // attributes are used for segmenting users
			"favorite_color": "green",
		},
	))

	slog.Info(flagName,
		"value", value,
		"error", err,
	)
}
