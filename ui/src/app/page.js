'use client'
import { useEffect, useRef, useState } from "react"
import BackendStatus from "./components/BackendStatus"
import ProcessedFilePreview from "./components/ProcessedFilePreview"

export default function Home() {
  const [file, setFile] = useState(null)
  const [message, setMessage] = useState("")
  const [uploaded, setUploaded] = useState(false)
  const dropRef = useRef()

  const handleDrop = (e) => {
    e.preventDefault()
    const droppedFile = e.dataTransfer.files[0]
    setFile(droppedFile)
    setMessage("")
    setUploaded(false)
  }

  const handleDragOver = (e) => {
    e.preventDefault()
  }

  const handleFileSelect = (e) => {
    const selected = e.target.files[0]
    setFile(selected)
    setMessage("")
    setUploaded(false)
  }

  const handleUpload = async () => {
    if (!file) {
      setMessage("⛔ لطفاً یک فایل انتخاب یا دراپ کنید")
      return
    }

    const formData = new FormData()
    formData.append("file", file)

    try {
      const res = await fetch("http://localhost:8080/upload", {
        method: "POST",
        body: formData,
      })

      const text = await res.text()
      setMessage(text)
      if (res.ok) setUploaded(true)
    } catch (err) {
      setMessage("❌ خطا در ارسال فایل")
    }
  }

  return (
    <main style={{ padding: "2rem", textAlign: "center" }}>
      <BackendStatus />

      <h1 style={{ margin: "2rem 0", fontSize: "1.5rem" }}>🖼️ آپلود عکس</h1>

      <div
        ref={dropRef}
        onDrop={handleDrop}
        onDragOver={handleDragOver}
        style={{
          border: "2px dashed #aaa",
          padding: "2rem",
          borderRadius: "10px",
          background: "#f9f9f9",
          cursor: "pointer",
          marginBottom: "1rem",
        }}
      >
        فایل را اینجا رها کنید یا از پایین انتخاب کنید
      </div>

      <input type="file" onChange={handleFileSelect} />
      <br /><br />

      <button
        onClick={handleUpload}
        style={{
          padding: "0.5rem 1.5rem",
          fontSize: "1rem",
          background: "#0070f3",
          color: "white",
          border: "none",
          borderRadius: "5px",
          cursor: "pointer"
        }}
      >
        ارسال
      </button>

      {message && (
        <p style={{ marginTop: "1rem", fontWeight: "bold" }}>{message}</p>
      )}

      {uploaded && file?.name && (
        <ProcessedFilePreview filename={file.name} />
      )}
    </main>
  )
}