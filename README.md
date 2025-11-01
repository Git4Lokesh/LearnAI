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
```
┌─────────────────────────────────────────────────────────────┐
│                         Client Browser                       │
│              (EJS Templates + Bootstrap + MathJax)           │
└────────────────────────┬────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────┐
│                     Express.js Server                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │ Auth Routes  │  │ Content Gen  │  │ API Endpoints│     │
│  │ (Passport)   │  │ Routes       │  │              │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
└────────┬────────────────┬────────────────┬─────────────────┘
         │                │                │
         ▼                ▼                ▼
┌─────────────┐  ┌──────────────┐  ┌─────────────────┐
│ PostgreSQL  │  │ Perplexity   │  │ BKT Service     │
│ Database    │  │ AI API       │  │ (FastAPI)       │
│             │  │              │  │                 │
│ - Users     │  │ - Sonar Pro  │  │ - Knowledge     │
│ - Quicknotes│  │ - Chat       │  │   Tracing       │
│ - Flashcards│  │              │  │ - Adaptive      │
│ - Quiz      │  │              │  │   Difficulty    │
└─────────────┘  └──────────────┘  └─────────────────┘
                         │
                         ▼
                 ┌──────────────┐
                 │ LlamaParse   │
                 │ API          │
                 │              │
                 │ - PDF        │
                 │   Extraction │
                 └──────────────┘
```

### Component Breakdown

**1. Frontend Layer**
- EJS templates render server-side
- Bootstrap 5 for responsive UI
- MathJax for mathematical equations
- Custom JavaScript for interactive features

**2. Application Layer**
- Express.js handles routing and middleware
- Passport.js manages authentication
- Session management with express-session
- Multer for file uploads

**3. Data Layer**
- PostgreSQL stores user data and content
- In-memory state for BKT calculations
- Session storage for temporary data

**4. AI Services Layer**
- Perplexity AI for content generation
- LlamaParse for PDF processing
- Custom BKT service for adaptive learning

---

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download](https://nodejs.org/)
- **PostgreSQL** (v14 or higher) - [Download](https://www.postgresql.org/download/)
- **Python** (v3.11 or higher) - [Download](https://www.python.org/downloads/)
- **Docker** (optional, for containerized deployment) - [Download](https://www.docker.com/products/docker-desktop/)

### API Keys Required

You'll need to obtain the following API keys:

1. **Perplexity AI API Key** - [Get it here](https://www.perplexity.ai/)
2. **LlamaCloud API Key** - [Get it here](https://cloud.llamaindex.ai/)

---

## 🚀 Installation

### Option 1: Local Development Setup

#### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/learn-ai.git
cd learn-ai
```

#### 2. Install Dependencies
```bash
# Install Node.js dependencies
npm install

# Install Python dependencies for BKT service
cd bkt_service
pip install -r requirements.txt
cd ..
```

#### 3. Set Up PostgreSQL Database
```bash
# Login to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE "Content Storage";

# Create tables
\c "Content Storage"

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE quicknotes (
    id SERIAL PRIMARY KEY,
    topic VARCHAR(255) NOT NULL,
    grade_level VARCHAR(50) NOT NULL,
    note_content TEXT NOT NULL,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE flashcards (
    id SERIAL PRIMARY KEY,
    topic VARCHAR(255) NOT NULL,
    grade_level VARCHAR(50) NOT NULL,
    card_content JSONB NOT NULL,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(topic, grade_level, user_id)
);

CREATE TABLE quiz (
    id SERIAL PRIMARY KEY,
    topic VARCHAR(255) NOT NULL,
    grade_level VARCHAR(50) NOT NULL,
    content JSONB NOT NULL,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

#### 4. Configure Environment Variables

Create a `.env` file in the root directory:
```env
# Server Configuration
PORT=3000
NODE_ENV=development

# Database Configuration
DATABASE_URL=postgresql://postgres:postgrespass1!@localhost:5432/Content Storage

# Session Secret (generate a random string)
SESSION_SECRET=your-super-secret-session-key-here

# API Keys
PERPLEXITY_API_KEY=your-perplexity-api-key
LLAMA_CLOUD_API_KEY=your-llama-cloud-api-key

# BKT Service URL
BKT_BASE_URL=http://127.0.0.1:8000
```

#### 5. Start the Application
```bash
# Start BKT service (in a separate terminal)
cd bkt_service
python -m uvicorn main:app --host 127.0.0.1 --port 8000

# Start main application (in another terminal)
npm start
```

The application will be available at `http://localhost:3000`

---

### Option 2: Docker Deployment

#### 1. Configure Environment Variables

Create a `.env` file with your configuration (same as above).

#### 2. Build and Run with Docker Compose
```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

The application will be available at `http://localhost:3000`

---

## ⚙️ Configuration

### Database Configuration

Update the database connection in `app.js`:
```javascript
const db = new pg.Client({
  host: 'localhost',
  port: 5432,
  user: 'postgres',
  password: 'your-password',
  database: 'Content Storage',
});
```

### BKT Parameters

Customize the Bayesian Knowledge Tracing parameters in `bkt_service/main.py`:
```python
DEFAULT_P_INIT = 0.2   # Prior mastery probability
DEFAULT_P_LEARN = 0.15 # Learning rate
DEFAULT_P_GUESS = 0.2  # Guessing probability
DEFAULT_P_SLIP = 0.1   # Slip probability
```

### File Upload Limits

Adjust file upload size in `app.js`:
```javascript
const upload = multer({
    storage: multer.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024 // 10MB limit
    },
    // ...
});
```

---

## 📖 Usage

### Creating Study Materials

1. **Sign Up / Log In**
   - Create an account or log in with existing credentials
   - Google OAuth is also supported

2. **Generate Content**
   - Choose input method: Topic or PDF Upload
   - Select your grade level (Elementary, Middle School, High School, College)
   - Choose study type: Quick Notes, Flashcards, or Quiz
   - Click "Generate Study Materials"

3. **Interact with Content**
   - **Quick Notes**: Highlight text for instant explanations
   - **Flashcards**: Navigate through cards, flip to see answers
   - **Quizzes**: Answer questions, get AI-powered analysis

4. **Mastery Mode**
   - Enter a topic and grade level
   - Answer questions until you reach 95% mastery
   - Difficulty adapts based on your performance

5. **Save & Export**
   - Save materials to your library
   - Export as HTML or JSON
   - Access saved content anytime

### Using the AI Chat Assistant

1. Click the "AI Assistant" button
2. Ask questions about your study materials
3. Get instant, contextual responses
4. Conversation history is maintained per session

---

## 📁 Project Structure
```
learn-ai/
├── 📁 bkt_service/              # Bayesian Knowledge Tracing service
│   ├── main.py                  # FastAPI application
│   ├── requirements.txt         # Python dependencies
│   └── Dockerfile               # BKT service container
│
├── 📁 public/                   # Static assets
│   └── 📁 css/
│       └── style.css            # Custom styles
│
├── 📁 services/                 # Business logic services
│   ├── bktClient.js             # BKT API client
│   ├── bktRunner.js             # BKT service manager
│   └── chatService.js           # AI chat functionality
│
├── 📁 views/                    # EJS templates
│   ├── dashboard.ejs            # Main dashboard
│   ├── quicknotes.ejs           # Notes viewer
│   ├── flashcards.ejs           # Flashcard interface
│   ├── quiz.ejs                 # Quiz interface
│   ├── master.ejs               # Mastery mode
│   ├── chat.ejs                 # AI chat assistant
│   ├── saved-content.ejs        # Content library
│   ├── login.ejs                # Login page
│   └── signup.ejs               # Registration page
│
├── app.js                       # Main application file
├── package.json                 # Node.js dependencies
├── Dockerfile                   # Main app container
├── docker-compose.yml           # Multi-container orchestration
└── .env.example                 # Environment variables template
```

---

## 🔌 API Reference

### Authentication Endpoints
```http
POST /signup
Content-Type: application/json

{
  "fullName": "John Doe",
  "email": "john@example.com",
  "password": "securepassword"
}
```
```http
POST /login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "securepassword"
}
```

### Content Generation
```http
POST /generate
Content-Type: multipart/form-data

{
  "topic": "Photosynthesis",
  "gradeLevel": "high",
  "studyType": "quiz",
  "inputMethod": "topic"
}
```

### BKT Service
```http
POST http://localhost:8000/update
Content-Type: application/json

{
  "userId": "user123",
  "skillId": "algebra",
  "correct": true
}
```
```http
POST http://localhost:8000/next
Content-Type: application/json

{
  "userId": "user123",
  "skillId": "algebra"
}
```

### Chat Assistant
```http
POST /api/chat
Content-Type: application/json

{
  "message": "Explain the quadratic formula",
  "sessionId": "session123"
}
```

### Content Management
```http
GET /api/quicknotes
GET /api/flashcards
GET /api/quiz

DELETE /delete-content/quicknotes/:id
DELETE /delete-content/flashcards/:id
DELETE /delete-content/quiz/:id

GET /export/quicknotes/:id
GET /export/flashcards/:id
GET /export/quiz/:id
```

---

## 🎨 UI Themes & Customization

The application uses a **Royal Dark Theme** with customizable CSS variables:
```css
:root {
    --royal-purple: #7C3AED;
    --royal-blue: #2563EB;
    --royal-gold: #F59E0B;
    --dark-bg: #0F172A;
    --dark-card: #1E293B;
    --dark-border: #334155;
}
```

Modify these in `public/css/style.css` to customize the color scheme.

---

## 🧪 Testing
```bash
# Run tests (if test suite is set up)
npm test

# Run linting
npm run lint

# Check for security vulnerabilities
npm audit
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
```bash
   git checkout -b feature/amazing-feature
```
3. **Commit your changes**
```bash
   git commit -m 'Add some amazing feature'
```
4. **Push to the branch**
```bash
   git push origin feature/amazing-feature
```
5. **Open a Pull Request**

### Coding Standards

- Follow ESLint configuration
- Write meaningful commit messages
- Add comments for complex logic
- Update documentation for new features

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Perplexity AI** for providing the Sonar Pro API
- **LlamaIndex** for PDF parsing capabilities
- **Bootstrap** for the responsive UI framework
- **MathJax** for mathematical notation rendering
- **FastAPI** for the efficient Python backend

---

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/yourusername/learn-ai/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/learn-ai/discussions)
- **Email**: support@learnai.example.com

---

## 🗺️ Roadmap

- [ ] Mobile app (React Native)
- [ ] Spaced repetition algorithm
- [ ] Collaborative study groups
- [ ] Video content generation
- [ ] Multi-language support
- [ ] Voice-to-text input
- [ ] Integration with LMS platforms

---

<div align="center">

**Made with ❤️ by the Learn.ai Team**

⭐ Star us on GitHub if you find this project helpful!

[Website](https://learnai.example.com) • [Documentation](https://docs.learnai.example.com) • [Blog](https://blog.learnai.example.com)

</div>
