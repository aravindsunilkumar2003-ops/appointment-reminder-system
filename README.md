# WhatsApp Appointment Reminder System
**Better Call Centers / El Paso Water Quality LLC — Practical Test Submission**

---

## Live Demo
> Deploy link: _(see submission email)_

---

## What It Does

| Feature | Details |
|---|---|
| Appointment form | Name, phone (E.164), date/time |
| Saves to database | Supabase (PostgreSQL) in live mode · in-memory array in demo mode |
| WhatsApp / SMS confirmation | Twilio API — real send in live mode · simulated with full log in demo |
| Live dashboard | Polls every 10 seconds — no hardcoded data |
| **BONUS** Auto-reminder | Server polls every 60 s — sends if appointment ≤ 1 hour away, sets `reminder_sent=true` to prevent duplicates |
| Message log tab | Shows every sent message with SID, body, timestamp, and LIVE/SIMULATED tag |

---

## Modes

The server auto-detects which credentials are present and switches mode automatically.

| Mode | DB | Messaging | When |
|---|---|---|---|
| **DEMO** | In-memory JS array | Simulated (logged to `/api/messages`) | No `.env` set |
| **LIVE** | Supabase PostgreSQL | Real Twilio WhatsApp or SMS | `.env` filled |

---

## Quick Start (Local)

```bash
git clone <repo-url>
cd appointment-reminder-system
npm install
node server.js          # DEMO mode — no credentials needed
# → http://localhost:3000
```

To go live, copy `.env.example` → `.env` and fill in your keys, then `node server.js` again.

---

## Deploy to Render (free tier — get a live URL)

1. Push this folder to a GitHub repo
2. Go to [render.com](https://render.com) → **New → Web Service**
3. Connect your GitHub repo
4. Settings:
   - **Build command:** `npm install`
   - **Start command:** `node server.js`
5. Click **Deploy** — Render gives you a URL like `https://your-app.onrender.com`
6. *(Optional)* Add environment variables in Render dashboard for live Supabase + Twilio

---

## Supabase Setup (live mode only)

Run `supabase_schema.sql` in your Supabase SQL Editor once.

---

## Project Structure

```
├── server.js              ← All backend logic: routes, DB layer, Twilio, reminder poller
├── public/
│   └── index.html         ← Frontend: form + live dashboard + message log (vanilla JS)
├── supabase_schema.sql    ← Run once in Supabase to create the appointments table
├── .env.example           ← Copy to .env and fill in credentials for live mode
└── package.json
```

---

## API Endpoints

| Method | Path | What it does |
|---|---|---|
| `POST` | `/api/appointments` | Create appointment, save to DB, send confirmation |
| `GET`  | `/api/appointments` | Return all appointments (used by dashboard) |
| `PATCH`| `/api/appointments/:id` | Update status (confirmed/completed/cancelled) |
| `GET`  | `/api/messages` | Return message log with SIDs |
| `GET`  | `/api/status` | Health check — shows mode, uptime |

---

## Written Explanation (Submission Requirement)

I built a full-stack WhatsApp appointment reminder system using **Node.js + Express** for the backend, **Supabase (PostgreSQL)** for the database, and **Twilio** for WhatsApp/SMS messaging. When the form is submitted, the server inserts a row into Supabase, then immediately calls Twilio's API to send a confirmation message to the customer's phone — the Twilio message SID is saved back to the row as an audit trail. The frontend dashboard calls `GET /api/appointments` every 10 seconds and re-renders the table live, with no hardcoded data. A `setInterval` poller runs on the server every 60 seconds, queries for confirmed appointments within the next hour where `reminder_sent = false`, sends a reminder via Twilio, then sets `reminder_sent = true` — the database flag guarantees exactly one reminder per appointment even across server restarts. The server runs in DEMO mode automatically when no credentials are present, simulating the Twilio send and logging every message to `/api/messages` so a reviewer can see the exact API call that would go out. The hardest part was the reminder deduplication logic: making sure a reminder can never fire twice even if the poller runs concurrently or the server restarts between the send and the flag write. Total time: approximately 4 hours 30 minutes.

---

## Time Taken

| Task | Time |
|---|---|
| Docs + planning | 30 min |
| Backend (routes, DB layer, Twilio, reminder poller) | 1 hr 30 min |
| Frontend (form, dashboard, message log, styling) | 1 hr 30 min |
| Testing + Supabase schema | 30 min |
| README + submission documents | 30 min |
| **Total** | **~4 hrs 30 min** |
