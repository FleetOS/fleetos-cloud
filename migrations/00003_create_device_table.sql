-- +goose Up
-- +goose StatementBegin
CREATE TABLE devices (
    id SERIAL PRIMARY KEY,
    cert_fingerprint VARCHAR(255) NOT NULL UNIQUE,
    device_uuid VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE devices;
-- +goose StatementEnd
