-- +goose Up
-- +goose StatementBegin
CREATE TABLE user_teams (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    team_id INTEGER NOT NULL REFERENCES teams(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, team_id)
);

CREATE INDEX idx_user_teams_user_id ON user_teams(user_id);
CREATE INDEX idx_user_teams_team_id ON user_teams(team_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE user_teams;
-- +goose StatementEnd
