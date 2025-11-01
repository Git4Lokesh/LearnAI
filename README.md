# 🎓 Learn.ai - AI-Powered Study Materials Generator

<div align="center">

![Learn.ai Banner](https://img.shields.io/badge/Learn.ai-AI%20Study%20Platform-7C3AED?style=for-the-badge&logo=robot&logoColor=white)

**Transform any topic into comprehensive study materials instantly with the power of AI**

[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?style=flat-square&logo=node.js&logoColor=white)](https://nodejs.org/)
[![Express](https://img.shields.io/badge/Express-4.x-000000?style=flat-square&logo=express&logoColor=white)](https://expressjs.com/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-336791?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![Python](https://img.shields.io/badge/Python-3.11+-3776AB?style=flat-square&logo=python&logoColor=white)](https://www.python.org/)

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Architecture](#-architecture) • [API](#-api-reference)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Architecture](#-architecture)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Configuration](#-configuration)
- [Usage](#-usage)
- [Project Structure](#-project-structure)
- [API Reference](#-api-reference)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🌟 Overview

**Learn.ai** is an intelligent study materials generator that leverages cutting-edge AI technology to create personalized learning content. Whether you're a student preparing for exams or a lifelong learner exploring new topics, Learn.ai transforms any subject into comprehensive study materials including notes, flashcards, and interactive quizzes.

### 🎯 Key Highlights

- **AI-Powered Generation**: Utilizes Perplexity AI's Sonar Pro model for intelligent content creation
- **Adaptive Learning**: Implements Bayesian Knowledge Tracing (BKT) for personalized difficulty adjustment
- **Multi-Format Support**: Upload PDFs or enter topics directly
- **Interactive Experience**: Text selection for instant explanations, real-time chat assistance
- **Mathematical Support**: Full LaTeX/MathJax rendering for STEM subjects
- **Persistent Storage**: Save, export, and revisit your study materials anytime

---

## ✨ Features

### 📚 Study Material Types

<table>
<tr>
<td width="33%" valign="top">

#### 📝 Quick Notes
- Comprehensive study notes
- Structured with headings and bullet points
- Interactive text selection for deeper explanations
- Export to HTML
- Print-friendly format

</td>
<td width="33%" valign="top">

#### 🎴 Flashcards
- Question-answer pairs
- Flip animation
- Progress tracking
- Navigation controls
- Bulk generation (10 cards per topic)

</td>
<td width="33%" valign="top">

#### ❓ Interactive Quizzes
- Multiple-choice questions
- Instant feedback
- Performance analytics
- AI-powered recommendations
- Adaptive difficulty (BKT)

</td>
</tr>
</table>

### 🚀 Advanced Features

- **🎯 Mastery Mode**: Practice until you achieve 95%+ mastery with adaptive difficulty
- **💬 AI Chat Assistant**: Get instant help with study questions
- **📄 PDF Processing**: Upload course materials and generate study content from them
- **🔍 Smart Text Selection**: Highlight any text for explanations, examples, simplifications, or context
- **📊 Progress Tracking**: Monitor your learning journey with BKT-powered analytics
- **🔐 User Authentication**: Secure login with email/password or Google OAuth
- **💾 Content Management**: Save, organize, and export all your study materials
- **📱 Responsive Design**: Beautiful royal dark theme, works on all devices

---

## 🛠 Tech Stack

### Frontend
- **EJS** - Templating engine
- **Bootstrap 5** - UI framework
- **Bootstrap Icons** - Icon library
- **MathJax 3** - Mathematical notation rendering
- **Custom CSS** - Royal dark theme

### Backend
- **Node.js 18+** - JavaScript runtime
- **Express.js** - Web framework
- **PostgreSQL** - Primary database
- **Passport.js** - Authentication middleware
- **BCrypt** - Password hashing

### AI & Machine Learning
- **Perplexity AI (Sonar Pro)** - Content generation
- **LangChain** - Chat conversation management
- **LlamaParse** - PDF text extraction
- **FastAPI** - BKT service (Python)
- **NumPy** - Mathematical computations

### DevOps
- **Docker & Docker Compose** - Containerization
- **Uvicorn** - ASGI server for Python
- **Multer** - File upload handling

---

## 🏗 Architecture
