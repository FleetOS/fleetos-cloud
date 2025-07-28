package mqtt

import (
	"context"
	"log/slog"

	mqtt "github.com/eclipse/paho.mqtt.golang"
	"github.com/fleetos/fleetos-cloud/internal/repositories"
	"github.com/jmoiron/sqlx"
)

type MqttService struct {
	Logger  *slog.Logger
	Db      *sqlx.DB
	Queries *repositories.Queries
	Ctx     context.Context
}

func NewMqttService(logger *slog.Logger, db *sqlx.DB, queries *repositories.Queries, ctx context.Context) MqttService {
	return MqttService{
		Logger:  logger,
		Db:      db,
		Queries: queries,
		Ctx:     ctx,
	}
}

func (m *MqttService) NewDeviceLocationMessage(client mqtt.Client, message mqtt.Message) {
}
