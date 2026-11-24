-- Supabase Schema for Portfolio Admin Panel
-- Run this in your Supabase SQL editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Projects table
CREATE TABLE projects (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    link TEXT,
    tags TEXT[] DEFAULT '{}',
    cover_url TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tools table
CREATE TABLE tools (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    icon_url TEXT,
    icon_svg TEXT,
    sort_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Messages table
CREATE TABLE messages (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Storage bucket for project covers
INSERT INTO storage.buckets (id, name, public) VALUES ('covers', 'covers', true);

-- Enable Row Level Security
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

-- Projects: anyone can SELECT, only admin can modify
CREATE POLICY "Public can view projects" ON projects FOR SELECT USING (true);
CREATE POLICY "Admin can manage projects" ON projects FOR ALL USING (
    auth.uid() IS NOT NULL AND 
    auth.email() = 'manpreetsirohi26@gmail.com'
);

-- Tools: anyone can SELECT, only admin can modify
CREATE POLICY "Public can view tools" ON tools FOR SELECT USING (true);
CREATE POLICY "Admin can manage tools" ON tools FOR ALL USING (
    auth.uid() IS NOT NULL AND 
    auth.email() = 'manpreetsirohi26@gmail.com'
);

-- Messages: anyone can INSERT, only admin can SELECT/DELETE
CREATE POLICY "Anyone can send messages" ON messages FOR INSERT WITH CHECK (true);
CREATE POLICY "Admin can view messages" ON messages FOR SELECT USING (
    auth.uid() IS NOT NULL AND 
    auth.email() = 'manpreetsirohi26@gmail.com'
);
CREATE POLICY "Admin can delete messages" ON messages FOR DELETE USING (
    auth.uid() IS NOT NULL AND 
    auth.email() = 'manpreetsirohi26@gmail.com'
);

-- Storage policies
CREATE POLICY "Public can view cover images" ON storage.objects FOR SELECT USING (bucket_id = 'covers');
CREATE POLICY "Admin can upload covers" ON storage.objects FOR INSERT WITH CHECK (
    bucket_id = 'covers' AND
    auth.uid() IS NOT NULL AND 
    auth.email() = 'manpreetsirohi26@gmail.com'
);
CREATE POLICY "Admin can update covers" ON storage.objects FOR UPDATE USING (
    bucket_id = 'covers' AND
    auth.uid() IS NOT NULL AND 
    auth.email() = 'manpreetsirohi26@gmail.com'
);
CREATE POLICY "Admin can delete covers" ON storage.objects FOR DELETE USING (
    bucket_id = 'covers' AND
    auth.uid() IS NOT NULL AND 
    auth.email() = 'manpreetsirohi26@gmail.com'
);

-- Seed initial projects
INSERT INTO projects (title, description, link, tags, sort_order) VALUES
('Sydney Immigration India', 'A professional website for immigration services', 'https://sydney-immigration.vercel.app', ARRAY['Web Design', 'Immigration'], 1),
('Zero Kata tic-tac-toe', 'Interactive tic-tac-toe game built with AI integration', 'https://zero-kata-tic-tac-toe.ai.studio', ARRAY['Game', 'AI'], 2),
('StudyMate AI', 'AI-powered study buddy application', 'https://studymate-ai-ai-study-buddy.ai.studio', ARRAY['AI', 'Education'], 3);