-- name: CreateUser :one
INSERT INTO users (email, password, username)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetUser :one
SELECT * FROM users
WHERE id = $1 LIMIT 1;

-- name: GetUserByEmail :one
SELECT * FROM users
WHERE email = $1 LIMIT 1;

-- name: GetUserByUsername :one
SELECT * FROM users
WHERE username = $1 LIMIT 1;

-- name: ListUsers :many
SELECT * FROM users
ORDER BY username;

-- name: UpdateUser :one
UPDATE users
SET email = $2, password = $3, username = $4, updated_at = CURRENT_TIMESTAMP
WHERE id = $1
RETURNING *;

-- name: DeleteUser :exec
DELETE FROM users
WHERE id = $1;

-- name: CreateTeam :one
INSERT INTO teams (name)
VALUES ($1)
RETURNING *;

-- name: GetTeam :one
SELECT * FROM teams
WHERE id = $1 LIMIT 1;

-- name: GetTeamByName :one
SELECT * FROM teams
WHERE name = $1 LIMIT 1;

-- name: ListTeams :many
SELECT * FROM teams
ORDER BY name;

-- name: UpdateTeam :one
UPDATE teams
SET name = $2, updated_at = CURRENT_TIMESTAMP
WHERE id = $1
RETURNING *;

-- name: DeleteTeam :exec
DELETE FROM teams
WHERE id = $1;

-- name: CreateDevice :one
INSERT INTO devices (cert_fingerprint, device_uuid, name)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetDevice :one
SELECT * FROM devices
WHERE id = $1 LIMIT 1;

-- name: GetDeviceByCertFingerprint :one
SELECT * FROM devices
WHERE cert_fingerprint = $1 LIMIT 1;

-- name: GetDeviceByUuid :one
SELECT * FROM devices
WHERE device_uuid = $1 LIMIT 1;

-- name: ListDevices :many
SELECT * FROM devices
ORDER BY name;

-- name: UpdateDevice :one
UPDATE devices
SET cert_fingerprint = $2, device_uuid = $3, name = $4, updated_at = CURRENT_TIMESTAMP
WHERE id = $1
RETURNING *;

-- name: DeleteDevice :exec
DELETE FROM devices
WHERE id = $1;

-- name: CreatePermission :one
INSERT INTO permissions (view_locations, view_route_history, manage_devices, manage_users, manage_team)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetPermission :one
SELECT * FROM permissions
WHERE id = $1 LIMIT 1;

-- name: ListPermissions :many
SELECT * FROM permissions
ORDER BY id;

-- name: UpdatePermission :one
UPDATE permissions
SET view_locations = $2, view_route_history = $3, manage_devices = $4, manage_users = $5, manage_team = $6, updated_at = CURRENT_TIMESTAMP
WHERE id = $1
RETURNING *;

-- name: DeletePermission :exec
DELETE FROM permissions
WHERE id = $1;

-- name: AddUserToTeam :exec
INSERT INTO user_teams (user_id, team_id)
VALUES ($1, $2);

-- name: RemoveUserFromTeam :exec
DELETE FROM user_teams
WHERE user_id = $1 AND team_id = $2;

-- name: GetUserTeams :many
SELECT t.* FROM teams t
JOIN user_teams ut ON t.id = ut.team_id
WHERE ut.user_id = $1
ORDER BY t.name;

-- name: GetTeamUsers :many
SELECT u.* FROM users u
JOIN user_teams ut ON u.id = ut.user_id
WHERE ut.team_id = $1
ORDER BY u.username;

-- name: IsUserInTeam :one
SELECT EXISTS(
    SELECT 1 FROM user_teams
    WHERE user_id = $1 AND team_id = $2
);

-- name: AssignUserTeamPermission :exec
INSERT INTO user_team_permissions (user_id, team_id, permission_id)
VALUES ($1, $2, $3);

-- name: RevokeUserTeamPermission :exec
DELETE FROM user_team_permissions
WHERE user_id = $1 AND team_id = $2 AND permission_id = $3;

-- name: GetUserTeamPermissions :many
SELECT p.* FROM permissions p
JOIN user_team_permissions utp ON p.id = utp.permission_id
WHERE utp.user_id = $1 AND utp.team_id = $2
ORDER BY p.id;

-- name: GetUserPermissionsInTeam :one
SELECT 
    p.view_locations,
    p.view_route_history,
    p.manage_devices,
    p.manage_users,
    p.manage_team
FROM permissions p
JOIN user_team_permissions utp ON p.id = utp.permission_id
WHERE utp.user_id = $1 AND utp.team_id = $2
LIMIT 1;

-- name: ListUserTeamPermissions :many
SELECT 
    u.id as user_id,
    u.username,
    t.id as team_id,
    t.name as team_name,
    p.id as permission_id,
    p.view_locations,
    p.view_route_history,
    p.manage_devices,
    p.manage_users,
    p.manage_team
FROM user_team_permissions utp
JOIN users u ON utp.user_id = u.id
JOIN teams t ON utp.team_id = t.id
JOIN permissions p ON utp.permission_id = p.id
ORDER BY u.username, t.name;

-- name: AddDeviceToTeam :exec
INSERT INTO team_devices (team_id, device_id)
VALUES ($1, $2);

-- name: RemoveDeviceFromTeam :exec
DELETE FROM team_devices
WHERE team_id = $1 AND device_id = $2;

-- name: GetTeamDevices :many
SELECT d.* FROM devices d
JOIN team_devices td ON d.id = td.device_id
WHERE td.team_id = $1
ORDER BY d.name;

-- name: GetDeviceTeams :many
SELECT t.* FROM teams t
JOIN team_devices td ON t.id = td.team_id
WHERE td.device_id = $1
ORDER BY t.name;

-- name: IsDeviceInTeam :one
SELECT EXISTS(
    SELECT 1 FROM team_devices
    WHERE team_id = $1 AND device_id = $2
);

-- name: GetUserDevicesInTeam :many
SELECT DISTINCT d.* FROM devices d
JOIN team_devices td ON d.id = td.device_id
JOIN user_teams ut ON td.team_id = ut.team_id
WHERE ut.user_id = $1 AND ut.team_id = $2
ORDER BY d.name;

-- name: GetUserAllDevices :many
SELECT DISTINCT d.* FROM devices d
JOIN team_devices td ON d.id = td.device_id
JOIN user_teams ut ON td.team_id = ut.team_id
WHERE ut.user_id = $1
ORDER BY d.name;

-- name: CountUsersByTeam :many
SELECT t.id, t.name, COUNT(ut.user_id) as user_count
FROM teams t
LEFT JOIN user_teams ut ON t.id = ut.team_id
GROUP BY t.id, t.name
ORDER BY t.name;

-- name: CountDevicesByTeam :many
SELECT t.id, t.name, COUNT(td.device_id) as device_count
FROM teams t
LEFT JOIN team_devices td ON t.id = td.team_id
GROUP BY t.id, t.name
ORDER BY t.name;
