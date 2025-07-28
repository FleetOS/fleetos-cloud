-- +goose Up
-- +goose StatementBegin
CREATE TABLE team_devices (
    team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    device_id INTEGER NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (team_id, device_id)
);

CREATE INDEX idx_team_devices_team_id ON team_devices(team_id);
CREATE INDEX idx_team_devices_device_id ON team_devices(device_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE team_devices;
-- +goose StatementEnd
