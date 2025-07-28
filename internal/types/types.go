package types

type Config struct {
	Port          string `env:"PORT"`
	Dev           bool   `env:"DEV"`
	DatabaseUrl   string `env:"DATABASE_URL"`
	CacheUrl      string `env:"CACHE_URL"`
	MqttBrokerUrl string `env:"MQTT_BROKER_URL"`
}
