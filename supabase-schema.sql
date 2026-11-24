-- Supabase Schema for Portfolio Admin Panel

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Profiles table (admin users)
CREATE TABLE profiles (
    id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Portfolio content table (all editable content)
CREATE TABLE portfolio_content (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    section TEXT NOT NULL, -- 'hero', 'about', 'projects', 'tools', 'contact', 'marquee'
    field_key TEXT NOT NULL, -- e.g., 'name', 'role', 'intro'
    field_value TEXT,
    field_type TEXT DEFAULT 'text', -- 'text', 'textarea', 'url', 'image', 'json'
    display_order INTEGER DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_by UUID REFERENCES profiles(id)
);

-- Projects table
CREATE TABLE projects (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    image_url TEXT,
    link_url TEXT,
    tags TEXT[], -- array of tags
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Tools table
CREATE TABLE tools (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name TEXT NOT NULL,
    icon_svg TEXT, -- SVG code
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Contact info table
CREATE TABLE contact_info (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    type TEXT NOT NULL, -- 'email', 'phone', 'instagram', 'location'
    value TEXT NOT NULL,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- Skills table
CREATE TABLE skills (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    skill_name TEXT NOT NULL,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE
);

-- Site settings table
CREATE TABLE site_settings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    setting_key TEXT UNIQUE NOT NULL,
    setting_value TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_content ENABLE ROW LEVEL SECURITY;
ALTER TABLE projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE tools ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_settings ENABLE ROW LEVEL SECURITY;

-- Policies: Only authenticated admins can manage content
CREATE POLICY "Admins can view all content" ON portfolio_content
    FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can insert content" ON portfolio_content
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can update content" ON portfolio_content
    FOR UPDATE USING (auth.uid() IS NOT NULL);

CREATE POLICY "Admins can delete content" ON portfolio_content
    FOR DELETE USING (auth.uid() IS NOT NULL);

-- Similar policies for other tables
CREATE POLICY "Admins can manage projects" ON projects FOR ALL USING (auth.uid() IS NOT NULL);
CREATE POLICY "Admins can manage tools" ON tools FOR ALL USING (auth.uid() IS NOT NULL);
CREATE POLICY "Admins can manage contact info" ON contact_info FOR ALL USING (auth.uid() IS NOT NULL);
CREATE POLICY "Admins can manage skills" ON skills FOR ALL USING (auth.uid() IS NOT NULL);
CREATE POLICY "Admins can manage site settings" ON site_settings FOR ALL USING (auth.uid() IS NOT NULL);

-- Public can read all content (for the portfolio website)
CREATE POLICY "Public can read portfolio content" ON portfolio_content FOR SELECT USING (true);
CREATE POLICY "Public can read projects" ON projects FOR SELECT USING (is_active = true);
CREATE POLICY "Public can read tools" ON tools FOR SELECT USING (is_active = true);
CREATE POLICY "Public can read contact info" ON contact_info FOR SELECT USING (is_active = true);
CREATE POLICY "Public can read skills" ON skills FOR SELECT USING (is_active = true);
CREATE POLICY "Public can read site settings" ON site_settings FOR SELECT USING (true);

-- Insert initial content
INSERT INTO site_settings (setting_key, setting_value) VALUES
('site_title', 'Manpreet Sirohi | Digital Marketer Portfolio'),
('site_description', 'Portfolio of Manpreet Sirohi, Digital Marketer');

INSERT INTO portfolio_content (section, field_key, field_value, field_type, display_order) VALUES
('hero', 'name', 'Manpreet', 'text', 1),
('hero', 'role', 'Digital marketer', 'text', 2),
('hero', 'tagline', 'Turning ideas into impactful digital experiences.', 'text', 3),
('hero', 'intro', 'Hi, I''m Manpreet Sirohi, a digital marketer from Kaithal, Haryana. I plan and create social media content, write scripts and SEO titles for YouTube videos, and use AI tools to build chatbots and websites for businesses.', 'textarea', 4),
('about', 'about_title', 'About me', 'text', 1),
('about', 'about_text_1', 'I''m a digital marketer who loves turning ideas into content people actually enjoy. I''m currently learning Digital Marketing with AI at Zed-King and studying BCA.', 'textarea', 2),
('about', 'about_text_2', 'I create content, from Instagram posts to YouTube videos, and I use AI tools to build chatbots, websites and scripts. I''m always eager to learn, adapt and grow.', 'textarea', 3),
('contact', 'contact_title', 'Let''s work together', 'text', 1),
('contact', 'contact_text', 'I''m open to new projects and collaborations. Let''s create something that gets real results.', 'textarea', 2),
('contact', 'cta_text', 'Message on Instagram', 'text', 3);