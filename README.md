# fisly_mobile
AI-ready mobile app for collecting and preparing receipts before accounting

# Fisly 📄✨

Fisly is a mobile-first application that helps individuals and small businesses
collect, organize, and prepare expense documents (receipts, invoices) before
sending them to their accountant.

Fisly is **not an accounting software**.  
It focuses on **document collection, classification, and preparation**.

---

## 🚀 Features

- 📱 Mobile-first (Flutter)
- 📸 Capture receipts via camera or upload PDF files
- 🧠 AI-ready architecture for receipt classification
- 🗂️ Monthly document organization (YYYY-MM)
- ✏️ Edit category and description before submission
- 🔐 Secure authentication with token-based session handling
- 🧱 Clean Architecture & modular design

---

## 🏗️ Architecture

Fisly follows **Clean Architecture** principles with a **feature-based structure**.


### Key Concepts
- State management: **Riverpod**
- Networking: **Dio** with interceptors
- Secure storage: **flutter_secure_storage**
- Modular & testable layers:
  - Presentation
  - Application
  - Data
  - Domain

---

## 🧠 Design Philosophy

- Keep the accounting process **simple and human-friendly**
- Avoid legal or regulatory responsibility
- Focus on **pre-accounting workflows**
- Ready for event-driven and AI-powered extensions

---

## 🛠️ Tech Stack

- **Flutter**
- **Riverpod**
- **Dio**
- **Secure Storage**
- **Clean Architecture**

---

## 📌 Status

Fisly is currently under active development.
Backend services and AI integrations are designed as pluggable modules.

---

## 📄 License

MIT
