# Supabase Setup Guide for Waypoint

## Step 1: Create a Supabase Project

1. Go to https://supabase.com
2. Sign up or log in (you can use GitHub)
3. Click **"New Project"**
4. Fill in:
   - **Name:** `waypoint` (or your preferred name)
   - **Database Password:** Choose a strong password (save this!)
   - **Region:** Choose closest to you (e.g., `US East`)
   - **Pricing Plan:** Free tier is fine to start
5. Click **"Create new project"**
6. Wait 2-3 minutes for the project to provision

## Step 2: Run the Database Schema

1. In your Supabase project dashboard, click **"SQL Editor"** in the left sidebar
2. Click **"+ New query"**
3. Copy the entire contents of `supabase-schema.sql`
4. Paste into the SQL editor
5. Click **"Run"** (or press Cmd/Ctrl + Enter)
6. You should see: "Success. No rows returned"

## Step 3: Get Your Connection Details

1. Click **"Project Settings"** (gear icon) in the left sidebar
2. Click **"API"** in the settings menu
3. Copy these two values:
   - **Project URL** (e.g., `https://xxxxx.supabase.co`)
   - **anon public** key (under "Project API keys" - the long key starting with `eyJ...`)

## Step 4: Configure Waypoint App

1. Go to https://pkim-1.github.io/waypoint/
2. Click the **⚙️ Settings** icon (top right)
3. Enter:
   - **Supabase URL:** Paste your Project URL
   - **Supabase Anon Key:** Paste your anon public key
4. Click **"Save"**

The app will:
- ✅ Show "Connected to Supabase"
- ✅ Auto-migrate any existing localStorage data
- ✅ Start syncing to the database

## Step 5: Verify It's Working

1. Create a test task in Waypoint
2. Go back to Supabase → **"Table Editor"**
3. Select the `tasks` table
4. You should see your task there!

## Optional: Configure AWS Bedrock for AI Parsing

If you want AI-powered transcript parsing:

1. In Waypoint Settings, also add:
   - **AWS Access Key ID:** Your AWS access key
   - **AWS Secret Access Key:** Your AWS secret key
   - **AWS Region:** `us-east-1` (or your Bedrock-enabled region)
2. The "Parse with AI" button will now work for meeting transcripts

## Security Notes

⚠️ **Current Setup:** The schema uses public RLS policies (anyone can read/write)

For production use, you should:
- Implement Supabase authentication
- Update RLS policies to filter by `auth.uid()`
- See: https://supabase.com/docs/guides/auth

## Troubleshooting

**"Not Found" error:**
- Check your Project URL is correct (should end with `.supabase.co`)
- Make sure you used the **anon public** key, not the service role key

**Data not syncing:**
- Open browser console (F12) and check for errors
- Verify tables were created (check Table Editor in Supabase)

**Need to reset:**
- Go to SQL Editor and run: `DROP SCHEMA public CASCADE; CREATE SCHEMA public;`
- Then re-run `supabase-schema.sql`
