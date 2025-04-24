'use client'
import { useEffect, useState } from "react"

export default function BackendStatus() {
  const [status, setStatus] = useState(null)

  useEffect(() => {
    const checkBackend = async () => {
      try {
        const res = await fetch("http://localhost:8080")
        if (res.ok) setStatus(true)
        else setStatus(false)
      } catch {
        setStatus(false)
      }
    }

    checkBackend()
  }, [])

  return (
    <div style={{
      fontWeight: "bold",
      marginBottom: "1rem",
      color: status === true ? "green" : status === false ? "red" : "gray"
    }}>
      {status === null && "⏳ در حال بررسی اتصال به بک‌اند..."}
      {status === true && "✅ اتصال با بک‌اند برقرار است"}
      {status === false && "❌ اتصال با بک‌اند برقرار نشد"}
    </div>
  )
}
