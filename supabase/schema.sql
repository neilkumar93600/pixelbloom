-- AI SEO Growth Engine - Supabase/PostgreSQL Schema
-- Multi-tenant core tables + indexes + enums

create extension if not exists "pgcrypto";

-- Enums
create type job_status as enum ('queued', 'running', 'retrying', 'completed', 'failed', 'cancelled');
create type issue_severity as enum ('critical', 'warning', 'opportunity');
create type search_intent as enum ('informational', 'navigational', 'commercial', 'transactional', 'local');
create type page_status as enum ('discovered', 'crawled', 'analyzed', 'error', 'blocked');

-- Profiles (maps to auth.users)
create table if not exists public.users (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users(id) on delete cascade,
  name text not null,
  domain text not null,
  normalized_domain text not null,
  plan_tier text not null default 'starter',
  crawl_limit int not null default 500,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (owner_id, normalized_domain)
);

create table if not exists public.jobs (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  job_type text not null,
  status job_status not null default 'queued',
  request_hash text,
  progress int not null default 0,
  attempts int not null default 0,
  max_attempts int not null default 3,
  last_error text,
  payload jsonb not null default '{}'::jsonb,
  result jsonb,
  queued_at timestamptz not null default now(),
  started_at timestamptz,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  unique (project_id, job_type, request_hash)
);

create table if not exists public.crawled_pages (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  url text not null,
  normalized_url text not null,
  status page_status not null default 'discovered',
  http_status int,
  canonical_url text,
  title text,
  meta_description text,
  h1_count int,
  h2_count int,
  word_count int,
  content_hash text,
  load_time_ms int,
  mobile_friendly boolean,
  indexable boolean,
  schema_types text[] default '{}',
  core_web_vitals jsonb,
  crawl_depth int default 0,
  discovered_at timestamptz,
  crawled_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (project_id, normalized_url)
);

create table if not exists public.internal_links (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  source_page_id uuid references public.crawled_pages(id) on delete cascade,
  target_page_id uuid references public.crawled_pages(id) on delete cascade,
  source_url text not null,
  target_url text not null,
  anchor_text text,
  follow boolean not null default true,
  link_context text,
  opportunity_score numeric(5,2),
  created_at timestamptz not null default now()
);

create table if not exists public.seo_audits (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  audit_version text not null default 'v1',
  health_score numeric(5,2) not null,
  summary text,
  totals jsonb not null default '{}'::jsonb,
  critical_count int not null default 0,
  warning_count int not null default 0,
  opportunity_count int not null default 0,
  run_by_job_id uuid references public.jobs(id) on delete set null,
  created_at timestamptz not null default now()
);

create table if not exists public.seo_audit_issues (
  id uuid primary key default gen_random_uuid(),
  audit_id uuid not null references public.seo_audits(id) on delete cascade,
  page_id uuid references public.crawled_pages(id) on delete set null,
  category text not null,
  severity issue_severity not null,
  title text not null,
  description text not null,
  recommendation text,
  impact_score numeric(5,2),
  evidence jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.keywords (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  keyword text not null,
  keyword_type text not null, -- primary, secondary, long_tail, question, semantic
  intent search_intent,
  difficulty int,
  volume int,
  cpc numeric(8,2),
  priority_score numeric(5,2),
  target_url text,
  source text not null default 'ai',
  created_at timestamptz not null default now()
);

create table if not exists public.topic_clusters (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  pillar_topic text not null,
  cluster_name text not null,
  description text,
  target_intent search_intent,
  estimated_articles int,
  created_at timestamptz not null default now()
);

create table if not exists public.topic_cluster_articles (
  id uuid primary key default gen_random_uuid(),
  cluster_id uuid not null references public.topic_clusters(id) on delete cascade,
  suggested_title text not null,
  primary_keyword text not null,
  secondary_keywords text[] default '{}',
  search_intent search_intent,
  outline jsonb,
  internal_links_to text[] default '{}',
  status text not null default 'planned',
  created_at timestamptz not null default now()
);

create table if not exists public.programmatic_pages (
  id uuid primary key default gen_random_uuid(),
  project_id uuid not null references public.projects(id) on delete cascade,
  slug text not null,
  page_type text not null, -- best-tools, city-landing, how-to, comparison
  primary_keyword text not null,
  secondary_keywords text[] default '{}',
  seo_title text not null,
  meta_description text not null,
  content_outline jsonb not null,
  schema_markup jsonb,
  internal_link_plan jsonb,
  publish_status text not null default 'draft',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (project_id, slug)
);

-- Indexes
create index if not exists idx_projects_owner on public.projects(owner_id);
create index if not exists idx_jobs_project_status on public.jobs(project_id, status);
create index if not exists idx_crawled_pages_project_status on public.crawled_pages(project_id, status);
create index if not exists idx_crawled_pages_project_url on public.crawled_pages(project_id, normalized_url);
create index if not exists idx_internal_links_project_source on public.internal_links(project_id, source_url);
create index if not exists idx_internal_links_project_target on public.internal_links(project_id, target_url);
create index if not exists idx_audits_project_created on public.seo_audits(project_id, created_at desc);
create index if not exists idx_keywords_project_type on public.keywords(project_id, keyword_type);
create index if not exists idx_programmatic_pages_project_type on public.programmatic_pages(project_id, page_type);

-- Optional trigger function for updated_at
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger set_users_updated_at before update on public.users
for each row execute function public.set_updated_at();
create trigger set_projects_updated_at before update on public.projects
for each row execute function public.set_updated_at();
create trigger set_crawled_pages_updated_at before update on public.crawled_pages
for each row execute function public.set_updated_at();
create trigger set_programmatic_pages_updated_at before update on public.programmatic_pages
for each row execute function public.set_updated_at();

-- Enable RLS
alter table public.users enable row level security;
alter table public.projects enable row level security;
alter table public.jobs enable row level security;
alter table public.crawled_pages enable row level security;
alter table public.internal_links enable row level security;
alter table public.seo_audits enable row level security;
alter table public.seo_audit_issues enable row level security;
alter table public.keywords enable row level security;
alter table public.topic_clusters enable row level security;
alter table public.topic_cluster_articles enable row level security;
alter table public.programmatic_pages enable row level security;

-- Base policies (owner-based tenancy)
create policy "Users can read own profile" on public.users
for select using (auth.uid() = id);
create policy "Users can update own profile" on public.users
for update using (auth.uid() = id);

create policy "Users can manage own projects" on public.projects
for all using (owner_id = auth.uid()) with check (owner_id = auth.uid());

create policy "Project scoped access jobs" on public.jobs
for all using (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
) with check (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
);

create policy "Project scoped access crawled_pages" on public.crawled_pages
for all using (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
) with check (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
);

create policy "Project scoped access internal_links" on public.internal_links
for all using (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
) with check (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
);

create policy "Project scoped access seo_audits" on public.seo_audits
for all using (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
) with check (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
);

create policy "Project scoped access keywords" on public.keywords
for all using (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
) with check (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
);

create policy "Project scoped access topic_clusters" on public.topic_clusters
for all using (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
) with check (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
);

create policy "Cluster article access via cluster ownership" on public.topic_cluster_articles
for all using (
  exists (
    select 1
    from public.topic_clusters tc
    join public.projects p on p.id = tc.project_id
    where tc.id = cluster_id and p.owner_id = auth.uid()
  )
) with check (
  exists (
    select 1
    from public.topic_clusters tc
    join public.projects p on p.id = tc.project_id
    where tc.id = cluster_id and p.owner_id = auth.uid()
  )
);

create policy "Project scoped access programmatic_pages" on public.programmatic_pages
for all using (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
) with check (
  exists (select 1 from public.projects p where p.id = project_id and p.owner_id = auth.uid())
);
