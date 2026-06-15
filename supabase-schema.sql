-- Waypoint Database Schema for Supabase
-- Run this in your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Team Members Table
CREATE TABLE IF NOT EXISTS team_members (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  email TEXT,
  avatar_color TEXT NOT NULL DEFAULT '#000099',
  source TEXT DEFAULT 'manual',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Meetings Table
CREATE TABLE IF NOT EXISTS meetings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  date DATE NOT NULL,
  participants JSONB DEFAULT '[]'::jsonb,
  transcript TEXT,
  source TEXT DEFAULT 'upload',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tasks Table
CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT DEFAULT '',
  status TEXT NOT NULL DEFAULT 'todo' CHECK (status IN ('todo', 'inprogress', 'done')),
  labels JSONB DEFAULT '[]'::jsonb,
  due_date DATE,
  checklist JSONB DEFAULT '[]'::jsonb,
  assignee_name TEXT,
  assignee_id UUID REFERENCES team_members(id) ON DELETE SET NULL,
  meeting_id UUID REFERENCES meetings(id) ON DELETE SET NULL,
  meeting_title TEXT,
  item_type TEXT,
  notes JSONB DEFAULT '[]'::jsonb,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ,
  sort_order INTEGER DEFAULT 0
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_assignee_id ON tasks(assignee_id);
CREATE INDEX IF NOT EXISTS idx_tasks_meeting_id ON tasks(meeting_id);
CREATE INDEX IF NOT EXISTS idx_tasks_due_date ON tasks(due_date);
CREATE INDEX IF NOT EXISTS idx_tasks_created_at ON tasks(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_team_members_name ON team_members(name);
CREATE INDEX IF NOT EXISTS idx_meetings_date ON meetings(date DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE meetings ENABLE ROW LEVEL SECURITY;
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Create policies for public access (adjust these based on your security needs)
-- WARNING: These policies allow anyone to read/write.
-- For production, you should implement proper authentication and user-specific policies.

-- Team Members Policies
CREATE POLICY "Allow public read access to team_members"
  ON team_members FOR SELECT
  USING (true);

CREATE POLICY "Allow public insert to team_members"
  ON team_members FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow public update to team_members"
  ON team_members FOR UPDATE
  USING (true);

CREATE POLICY "Allow public delete from team_members"
  ON team_members FOR DELETE
  USING (true);

-- Meetings Policies
CREATE POLICY "Allow public read access to meetings"
  ON meetings FOR SELECT
  USING (true);

CREATE POLICY "Allow public insert to meetings"
  ON meetings FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow public update to meetings"
  ON meetings FOR UPDATE
  USING (true);

CREATE POLICY "Allow public delete from meetings"
  ON meetings FOR DELETE
  USING (true);

-- Tasks Policies
CREATE POLICY "Allow public read access to tasks"
  ON tasks FOR SELECT
  USING (true);

CREATE POLICY "Allow public insert to tasks"
  ON tasks FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow public update to tasks"
  ON tasks FOR UPDATE
  USING (true);

CREATE POLICY "Allow public delete from tasks"
  ON tasks FOR DELETE
  USING (true);

-- Sample data (optional - comment out if you don't want sample data)
-- INSERT INTO team_members (name, avatar_color, source) VALUES
--   ('Paul Kim', '#000099', 'manual'),
--   ('Sample User', '#4248ED', 'manual');
