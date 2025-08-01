// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.29.0

package repositories

import (
	"database/sql"
	"time"
)

type Device struct {
	ID              int32          `json:"id"`
	CertFingerprint string         `json:"cert_fingerprint"`
	DeviceUuid      string         `json:"device_uuid"`
	Name            sql.NullString `json:"name"`
	CreatedAt       sql.NullTime   `json:"created_at"`
	UpdatedAt       sql.NullTime   `json:"updated_at"`
}

type GooseDbVersion struct {
	ID        int32     `json:"id"`
	VersionID int64     `json:"version_id"`
	IsApplied bool      `json:"is_applied"`
	Tstamp    time.Time `json:"tstamp"`
}

type Permission struct {
	ID               int32        `json:"id"`
	ViewLocations    sql.NullBool `json:"view_locations"`
	ViewRouteHistory sql.NullBool `json:"view_route_history"`
	ManageDevices    sql.NullBool `json:"manage_devices"`
	ManageUsers      sql.NullBool `json:"manage_users"`
	ManageTeam       sql.NullBool `json:"manage_team"`
	CreatedAt        sql.NullTime `json:"created_at"`
	UpdatedAt        sql.NullTime `json:"updated_at"`
}

type Team struct {
	ID        int32        `json:"id"`
	Name      string       `json:"name"`
	CreatedAt sql.NullTime `json:"created_at"`
	UpdatedAt sql.NullTime `json:"updated_at"`
}

type TeamDevice struct {
	TeamID    int32        `json:"team_id"`
	DeviceID  int32        `json:"device_id"`
	CreatedAt sql.NullTime `json:"created_at"`
}

type User struct {
	ID        int32        `json:"id"`
	Email     string       `json:"email"`
	Password  string       `json:"password"`
	Username  string       `json:"username"`
	CreatedAt sql.NullTime `json:"created_at"`
	UpdatedAt sql.NullTime `json:"updated_at"`
}

type UserTeam struct {
	UserID    int32        `json:"user_id"`
	TeamID    int32        `json:"team_id"`
	CreatedAt sql.NullTime `json:"created_at"`
}

type UserTeamPermission struct {
	UserID       int32        `json:"user_id"`
	TeamID       int32        `json:"team_id"`
	PermissionID int32        `json:"permission_id"`
	CreatedAt    sql.NullTime `json:"created_at"`
}
