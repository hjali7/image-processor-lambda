# 🖼️ Local Serverless Image Uploader with Lambda + S3 + Go + Next.js

یک پروژه کامل و تمرینی برای پیاده‌سازی سیستم آپلود و پردازش تصاویر با استفاده از معماری Serverless، به صورت کاملاً لوکال با استفاده از [LocalStack](https://localstack.cloud/).

---

## 🚀 تکنولوژی‌ها و ابزارها

- ⚙️ **LocalStack** – شبیه‌ساز کامل AWS به صورت لوکال
- 🐳 **Docker Compose** – مدیریت سرویس‌های لوکال
- 🐬 **Go** – بک‌اند سبک و سریع برای دریافت فایل و ارسال به S3
- 🐍 **Lambda (Python)** – پردازشگر تصویر بعد از آپلود
- 🌐 **Next.js** – رابط گرافیکی مدرن با قابلیت Drag & Drop
- ☁️ **S3 (LocalStack)** – ذخیره‌سازی تصاویر

---

## 📁 ساختار پروژه

```
.
├── backend/           # بک‌اند Go با API آپلود فایل
├── lambdas/           # کد فانکشن AWS Lambda (Python)
├── localstack/        # اسکریپت‌های init برای ساخت باکت و تریگر
├── scripts/           # فایل‌های Shell برای Setup اولیه
├── ui-next/           # رابط کاربری با Next.js
├── docker-compose.yml # بالا آوردن LocalStack
├── README.md
└── LICENSE
```

---

## ✅ ویژگی‌ها

- اتصال واقعی از UI به بک‌اند با fetch
- آپلود فایل از طریق فرم و دراگ اند دراپ
- ارسال فایل به S3 لوکال و تریگر کردن Lambda
- نمایش وضعیت اتصال به بک‌اند به صورت زنده
- ساختار ماژولار و قابل توسعه برای پروژه‌های آینده

---

## ⚙️ اجرای پروژه

### 1. راه‌اندازی LocalStack:

```bash
docker-compose up -d
```

### 2. اجرای اسکریپت آماده‌سازی:

```bash
docker exec -it localstack bash
cd /scripts
./init.sh
```

### 3. اجرای Go backend:

```bash
cd backend
go run main.go
```

### 4. اجرای رابط Next.js:

```bash
cd ui-next
npm install
npm run dev
```

و سپس برو به [http://localhost:3000](http://localhost:3000)

---

## 📸 نمونه رابط کاربری

- Drag & Drop فایل
- دکمه ارسال
- وضعیت اتصال به بک‌اند

---

## 📃 لایسنس

این پروژه تحت لایسنس MIT منتشر شده است. لطفاً فایل [LICENSE](./LICENSE) را ببینید.

---

## 👤 توسعه‌دهنده

**(HajAli)**