package main

import (
	"net/http"

	"github.com/go-chi/chi/v5"
)

func registerWebsocketHandler(r chi.Router) {
	r.Route("/devices", func(r chi.Router) {
		r.Get("/locations", func(w http.ResponseWriter, r *http.Request) {})
	})
}

func registerHttpHandlers(r chi.Router) {
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(200)
		w.Write([]byte("Hello, world!"))
	})

	r.Route("/teams", func(r chi.Router) {
		r.Post("/create", func(w http.ResponseWriter, r *http.Request) {})

		r.Delete("/delete", func(w http.ResponseWriter, r *http.Request) {})

		r.Post("/add-user", func(w http.ResponseWriter, r *http.Request) {})

		r.Delete("/remove-user", func(w http.ResponseWriter, r *http.Request) {})

		r.Patch("/user-permissions", func(w http.ResponseWriter, r *http.Request) {})

		r.Post("/register-device", func(w http.ResponseWriter, r *http.Request) {})

		r.Delete("/delete-device", func(w http.ResponseWriter, r *http.Request) {})
	})

	r.Route("/auth", func(r chi.Router) {
		r.Post("/signup", func(w http.ResponseWriter, r *http.Request) {})

		r.Post("/login", func(w http.ResponseWriter, r *http.Request) {})

		r.Post("/logout", func(w http.ResponseWriter, r *http.Request) {})

		r.Delete("/delete", func(w http.ResponseWriter, r *http.Request) {})
	})

	r.Route("/devices", func(r chi.Router) {
		r.Get("/history", func(w http.ResponseWriter, r *http.Request) {})
	})
}
