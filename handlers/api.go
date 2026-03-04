package handlers

import (
	"net/http"
	"strconv"
	"strings"
	"time"

	"forum/database"
	api "forum/forum-api"
)

func CreatePost(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/posts/create" {
		// handle error with just a status
		// HandleError(w, http.StatusNotFound, "Page not found")
		return
	}
	if r.Method != http.MethodPost {
		// HandleError(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}

	title := strings.TrimSpace(r.FormValue("title"))
	text := r.FormValue("text")

	// handle empty title or text !!!

	// get user id
	var userId int
	cookie, _ := r.Cookie("session_id")
	err := database.Database.QueryRow(
		"SELECT user_id FROM sessions WHERE id = ?",
		cookie.Value,
	).Scan(&userId)

	// create post
	_, err = database.Database.Exec(
		"INSERT INTO posts (user_id, created_at, title, text) VALUES (?, ?, ?, ?)",
		userId,
		time.Now(),
		title,
		text,
	)
	// create session if you want to redirect to its page
	if err != nil {
		// log.Println(err.Error())
		// HandleError(w, http.StatusInternalServerError, "Could not create account")
		return
	}
	http.Redirect(w, r, "/", http.StatusSeeOther)
}

func CreateComment(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/comments/create" {
		// handle error with just a status
		// HandleError(w, http.StatusNotFound, "Page not found")
		return
	}
	if r.Method != http.MethodPost {
		// HandleError(w, http.StatusMethodNotAllowed, "Method not allowed")
		return
	}

	postId := r.FormValue("postId")
	text := r.FormValue("text") // trim space ?!

	// handle empty title or text !!!

	// get user id
	var userId int
	cookie, _ := r.Cookie("session_id")
	err := database.Database.QueryRow(
		"SELECT user_id FROM sessions WHERE id = ?",
		cookie.Value,
	).Scan(&userId)

	// create post
	_, err = database.Database.Exec(
		"INSERT INTO comments (user_id, post_id, created_at, text) VALUES (?, ?, ?, ?)",
		userId,
		postId,
		time.Now(),
		text,
	)
	// create session if you want to redirect to its page
	if err != nil {
		// log.Println(err.Error())
		// HandleError(w, http.StatusInternalServerError, "Could not create account")
		return
	}
	http.Redirect(w, r, "/", http.StatusSeeOther)
}

///////////////////////////////////////////////////////////

func PostResolver(w http.ResponseWriter, r *http.Request) {
	endpoint := r.PathValue("endpoint")
	cookie, _ := r.Cookie("session_id") // http.ErrNoCookie
	user, _ := getUser(cookie.Value)
	postId, _ := strconv.Atoi(r.PathValue("id"))

	switch endpoint {
	case "like":
		if r.Method != http.MethodPost {
			HandleError(w, http.StatusMethodNotAllowed, "Method not allowed")
			return
		}
		api.ReactToPost(user.Id, postId, true)

	case "dislike":
		if r.Method != http.MethodPost {
			HandleError(w, http.StatusMethodNotAllowed, "Method not allowed")
			return
		}
		api.ReactToPost(user.Id, postId, false)

		// + case delete
	}
}

func CommentResolver(w http.ResponseWriter, r *http.Request) {
	endpoint := r.PathValue("endpoint")
	cookie, _ := r.Cookie("session_id") // http.ErrNoCookie
	user, _ := getUser(cookie.Value)
	commentId, _ := strconv.Atoi(r.PathValue("id"))

	switch endpoint {
	case "like":
		if r.Method != http.MethodPost {
			HandleError(w, http.StatusMethodNotAllowed, "Method not allowed")
			return
		}
		api.ReactToComment(user.Id, commentId, true)

	case "dislike":
		if r.Method != http.MethodPost {
			HandleError(w, http.StatusMethodNotAllowed, "Method not allowed")
			return
		}
		api.ReactToComment(user.Id, commentId, false)

		// + case delete
	}
}
