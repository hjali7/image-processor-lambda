package main

import (
    "bytes"
    "fmt"
    "io"
    "log"
    "net/http"

    "github.com/aws/aws-sdk-go/aws"
    "github.com/aws/aws-sdk-go/aws/credentials"
    "github.com/aws/aws-sdk-go/aws/session"
    "github.com/aws/aws-sdk-go/service/s3"
)

func main() {
    http.HandleFunc("/upload", uploadHandler)

    fmt.Println("🚀 Server running at http://localhost:8080")
    err := http.ListenAndServe(":8080", nil)
    if err != nil {
        log.Fatal("❌ Server error:", err)
    }
}

func uploadHandler(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodPost {
        http.Error(w, "Only POST allowed", http.StatusMethodNotAllowed)
        return
    }

    file, header, err := r.FormFile("file")
    if err != nil {
        http.Error(w, "❌ Could not read file", http.StatusBadRequest)
        return
    }
    defer file.Close()

    buffer := bytes.NewBuffer(nil)
    if _, err := io.Copy(buffer, file); err != nil {
        http.Error(w, "❌ Failed to read file", http.StatusInternalServerError)
        return
    }

    sess, err := session.NewSession(&aws.Config{
        Region:           aws.String("us-east-1"),
        Endpoint:         aws.String("http://localhost:4566"),
        S3ForcePathStyle: aws.Bool(true),
        Credentials:      credentials.NewStaticCredentials("test", "test", ""),
    })
    if err != nil {
        http.Error(w, "❌ AWS session error", http.StatusInternalServerError)
        return
    }

    svc := s3.New(sess)
    _, err = svc.PutObject(&s3.PutObjectInput{
        Bucket: aws.String("image-uploads"),
        Key:    aws.String(header.Filename),
        Body:   bytes.NewReader(buffer.Bytes()),
    })

    if err != nil {
        http.Error(w, "❌ Failed to upload", http.StatusInternalServerError)
        return
    }

    fmt.Fprintf(w, "✅ File uploaded: %s", header.Filename)
}
