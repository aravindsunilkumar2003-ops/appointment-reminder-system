-- Run this once in Supabase SQL Editor before going live
-- Dashboard: supabase.com → your project → SQL Editor → New Query

CREATE TABLE IF NOT EXISTS appointments (
  id               UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name    TEXT        NOT NULL,
  phone_number     TEXT        NOT NULL,
  appointment_time TIMESTAMPTZ NOT NULL,
  status           TEXT        NOT NULL DEFAULT 'confirmed'
                               CHECK (status IN ('confirmed','reminder','completed','cancelled')),
  reminder_sent    BOOLEAN     NOT NULL DEFAULT FALSE,
  confirmation_sid TEXT,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Speeds up the reminder poller query
CREATE INDEX IF NOT EXISTS idx_reminder
  ON appointments (appointment_time, reminder_sent, status);

-- Open RLS policy for demo (tighten in production)
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "open_for_demo" ON appointments FOR ALL USING (true) WITH CHECK (true);
