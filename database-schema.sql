-- ResumeAI — Database Schema (PostgreSQL)
-- Phase 2: Database Design

-- USERS TABLE
CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    full_name TEXT,
    avatar_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- RESUMES TABLE
CREATE TABLE resumes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    summary TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- RESUME SECTIONS TABLE
CREATE TABLE resume_sections (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    resume_id uuid REFERENCES resumes(id) ON DELETE CASCADE,
    section_type TEXT NOT NULL, -- e.g., experience, education, skills
    content JSONB NOT NULL,
    position INT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- RESUME VERSIONS TABLE
CREATE TABLE resume_versions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    resume_id uuid REFERENCES resumes(id) ON DELETE CASCADE,
    version_number INT NOT NULL,
    data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- JOB DESCRIPTIONS TABLE
CREATE TABLE job_descriptions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    title TEXT,
    company TEXT,
    description TEXT NOT NULL,
    url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- ATS SCORES TABLE
CREATE TABLE ats_scores (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    resume_id uuid REFERENCES resumes(id) ON DELETE CASCADE,
    job_description_id uuid REFERENCES job_descriptions(id) ON DELETE CASCADE,
    ats_score INT,
    keyword_score INT,
    impact_score INT,
    formatting_score INT,
    suggestions JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- AI CONVERSATIONS TABLE
CREATE TABLE ai_conversations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    type TEXT NOT NULL, -- e.g., resume, job, project, interview
    prompt TEXT NOT NULL,
    response TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- PORTFOLIO SITES TABLE
CREATE TABLE portfolio_sites (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE,
    subdomain TEXT UNIQUE NOT NULL, -- e.g., username.resumeai.site
    site_data JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- RLS POLICIES (EXAMPLES)
-- Enable RLS
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE resumes ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_sections ENABLE ROW LEVEL SECURITY;
ALTER TABLE resume_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE job_descriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE ats_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE portfolio_sites ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only access their own data
CREATE POLICY "Users can view own data" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "User can manage own resumes" ON resumes
    FOR ALL USING (user_id = auth.uid());

CREATE POLICY "User can manage own resume sections" ON resume_sections
    FOR ALL USING (
        resume_id IN (SELECT id FROM resumes WHERE user_id = auth.uid())
    );

CREATE POLICY "User can manage own resume versions" ON resume_versions
    FOR ALL USING (
        resume_id IN (SELECT id FROM resumes WHERE user_id = auth.uid())
    );

CREATE POLICY "User can manage own job descriptions" ON job_descriptions
    FOR ALL USING (user_id = auth.uid());

CREATE POLICY "User can manage own ats scores" ON ats_scores
    FOR ALL USING (
        resume_id IN (SELECT id FROM resumes WHERE user_id = auth.uid())
    );

CREATE POLICY "User can manage own ai conversations" ON ai_conversations
    FOR ALL USING (user_id = auth.uid());

CREATE POLICY "User can manage own portfolio sites" ON portfolio_sites
    FOR ALL USING (user_id = auth.uid());

-- End of schema
