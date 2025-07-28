package main

import (
	"context"
	"log"
	"log/slog"
	"net/http"
	"os"
	"time"

	"github.com/caarlos0/env/v10"
	"github.com/eclipse/paho.mqtt.golang"
	mqttService "github.com/fleetos/fleetos-cloud/internal/mqtt"
	"github.com/fleetos/fleetos-cloud/internal/repositories"
	"github.com/fleetos/fleetos-cloud/internal/types"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/jmoiron/sqlx"
	"github.com/joho/godotenv"

	_ "github.com/lib/pq"
)

var config types.Config
var logger *slog.Logger

func main() {
	logger = slog.New(slog.NewTextHandler(os.Stdout, nil))
	slog.SetDefault(logger)

	if _, err := os.Stat(".env"); err == nil {
		err := godotenv.Load()
		if err != nil {
			logger.Error("error parsing .env", "err", err)
			return
		}
	}

	if err := env.Parse(&config); err != nil {
		logger.Error("error parsing config", "err", err)
		return
	}

	conn, err := sqlx.Open("postgres", config.DatabaseUrl)
	if err != nil {
		logger.Error("error opening database connection", "err", err)
		return
	}
	defer conn.Close()

	queries := &repositories.Queries{}

	ctx := context.Background()

	mqtt.DEBUG = log.New(os.Stdout, "mqtt-debug=", 0)
	mqtt.ERROR = log.New(os.Stderr, "mqtt-error=", 0)

	opts := mqtt.
		NewClientOptions().
		AddBroker(config.MqttBrokerUrl).
		SetClientID("fleetos-cloud").
		SetKeepAlive(time.Minute).
		SetPingTimeout(5 * time.Second)

	mqttClient := mqtt.NewClient(opts)
	if token := mqttClient.Connect(); token.Wait() && token.Error() != nil {
		logger.Error("error connecting to mqtt broker", "err", token.Error())
		return
	}

	mqttService := mqttService.NewMqttService(logger, conn, queries, ctx)

	mqttClient.Subscribe("device_location", 1, mqttService.NewDeviceLocationMessage)

	r := chi.NewRouter()

	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	registerWebsocketHandler(r)
	registerHttpHandlers(r)

	http.ListenAndServe(":"+config.Port, r)
}
