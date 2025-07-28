-- +goose Up
-- +goose StatementBegin
CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    view_locations BOOLEAN DEFAULT FALSE,
    view_route_history BOOLEAN DEFAULT FALSE,
    manage_devices BOOLEAN DEFAULT FALSE,
    manage_users BOOLEAN DEFAULT FALSE,
    manage_team BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE permissions;
-- +goose StatementEnd
