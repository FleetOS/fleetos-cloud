-- +goose Up
-- +goose StatementBegin
CREATE TABLE user_team_permissions (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    permission_id INTEGER NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, team_id, permission_id)
);

CREATE INDEX idx_user_team_permissions_user_id ON user_team_permissions(user_id);
CREATE INDEX idx_user_team_permissions_team_id ON user_team_permissions(team_id);
CREATE INDEX idx_user_team_permissions_permission_id ON user_team_permissions(permission_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE user_team_permissions;
-- +goose StatementEnd
