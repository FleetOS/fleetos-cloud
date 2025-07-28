package websocket

import (
	"context"
	"log/slog"
	"net/http"

	"github.com/fleetos/fleetos-cloud/internal/repositories"
	"github.com/gorilla/websocket"
	"github.com/jmoiron/sqlx"
)

type WebsocketService struct {
	Logger  *slog.Logger
	Db      *sqlx.DB
	Queries *repositories.Queries
	Ctx     context.Context
}

func NewWebsocketService(logger *slog.Logger, db *sqlx.DB, queries *repositories.Queries, ctx context.Context) WebsocketService {
	return WebsocketService{
		Logger:  logger,
		Db:      db,
		Queries: queries,
		Ctx:     ctx,
	}
}

func (ws *WebsocketService) HandleNewLocationStreamingConnection(w http.ResponseWriter, r *http.Request) error {
	upgrader := websocket.Upgrader{
		// TODO: implement CheckOrigin such that only requests coming from the web
		// dashboard are valid
	}

	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		handleError(err, w, "websocket/upgrader", ws.Logger)
		return err
	}
	defer conn.Close()

	ctx, cancel := context.WithCancel(r.Context())
	defer cancel()

	go func() {
		defer cancel()

		for {
			select {
			case <-ctx.Done():
				return
			default:
				// TODO: stream location data to frontend
				break
			}
		}
	}()

	<-ctx.Done()

	return nil
}

func handleError(err error, w http.ResponseWriter, svc string, logger *slog.Logger) {
	if err != nil {
		http.Error(w, "there was an error processing your request", http.StatusInternalServerError)
		logger.Error("error processing request", "svc", svc, "err", err)
	}
}
