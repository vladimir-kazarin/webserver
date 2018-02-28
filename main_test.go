package main

import (
    "net/http"
    "net/http/httptest"
    "testing"
)

func TestEventNextHandler(t *testing.T) {
    request, _ := http.NewRequest("GET", "/linux", nil)
    response := httptest.NewRecorder()
    handler(response, request)
    expected := "Hi there, I love linu!"
    if response.Body.String() != expected {
        t.Fatalf("Got: %s\nExpected: %s",
            response.Body.String(), expected)
    }
}

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hi there, I love %s!", r.URL.Path[1:])
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
