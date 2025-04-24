'use client'
export default function ProcessedFilePreview({ filename }) {
  if (!filename) return null

  const url = `http://localhost:4566/image-processed/${filename}`

  return (
    <div style={{ marginTop: "2rem" }}>
      <h3>فایل پردازش‌شده:</h3>
      <a
        href={url}
        target="_blank"
        rel="noopener noreferrer"
        style={{ color: "blue", textDecoration: "underline" }}
      >
        دانلود / مشاهده فایل
      </a>
      <div style={{ marginTop: "1rem" }}>
        <img
          src={url}
          alt="پردازش‌شده"
          style={{ maxWidth: "100%", border: "1px solid #ccc" }}
        />
      </div>
    </div>
  )
}
