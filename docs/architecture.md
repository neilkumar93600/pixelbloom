# AI SEO Growth Engine — System Architecture

## 1) Product Strategy (CEO: Aria)

**North-star outcome:** Help websites grow organic traffic with automated, actionable SEO systems (audit → strategy → execution).

**Primary value loop:**
1. Connect domain and start crawl.
2. Detect technical + on-page SEO issues.
3. Generate prioritized growth roadmap.
4. Auto-generate scalable SEO pages and internal links.
5. Track execution and score improvements over time.

**Core multi-tenant business goals:**
- Support 10,000+ websites with isolation and fair usage controls.
- Keep first audit under 10 minutes for small-to-medium sites.
- Provide deterministic, explainable AI outputs with source evidence.

---

## 2) Technical Architecture (CTO: Linus)

## High-level Components

- **Frontend (Next.js App Router)**
  - Dashboard UI, audit results, keyword/topic builders, linking graph, reports.
- **API Layer (Next.js Route Handlers + Supabase Edge Functions)**
  - Authenticated orchestration endpoints.
  - Long-running jobs delegated to queue workers.
- **Crawler Engine (Node.js worker service)**
  - Robots.txt aware crawl, sitemap ingestion, canonical detection, link graph extraction.
- **AI Orchestration Engine**
  - Prompted pipelines for audit scoring, keyword clustering, metadata, content optimization.
- **Database (Supabase/PostgreSQL)**
  - Multi-tenant storage for projects, crawl artifacts, audits, keywords, clusters, generated pages.
- **Realtime + Storage (Supabase)**
  - Job progress updates, artifact snapshots (raw crawl json, exports).

## Deployment Topology

- **Vercel**: Next.js frontend + server endpoints.
- **Supabase**: Postgres + auth + storage + edge functions.
- **Worker runtime**: containerized Node.js services for crawl + heavy AI jobs.
- **Queue**: Postgres-backed jobs table (or pg-boss/Graphile Worker) for reliable retries.

## Scalability & Reliability Patterns

- Multi-tenant row-level security (RLS).
- Job orchestration with statuses (`queued`, `running`, `retrying`, `completed`, `failed`).
- Idempotent worker handlers keyed by `(project_id, job_type, request_hash)`.
- Crawl budget caps per plan and adaptive rate limiting by host.
- Cached AI intermediate artifacts to reduce token cost.
- Observability: structured logs, per-job traces, and SEO score drift metrics.

---

## 3) Team Implementation Breakdown

### Project Manager (Sarah) — Delivery Epics
1. Onboarding + project creation + domain verification.
2. Crawl + audit ingestion pipeline.
3. AI insight modules (keywords, topical authority, metadata, optimization).
4. Programmatic page generator + internal linking graph.
5. Reports/export + recurring recrawl scheduler.

### Backend Engineer (Neo)
- Build normalized schema + RLS.
- Implement crawl ingestion and audit scoring services.
- Build API routes for jobs, status, and generated outputs.

### Frontend Engineer (Jax)
- Build dashboard shell and data-heavy pages.
- Integrate charts, graph visualization, issue tables.
- Add optimistic updates + realtime progress components.

### UI/UX Designer (Maya)
- Premium dark glassmorphism visual system.
- Accessibility-first components with subtle motion.

### Prompt Engineer (Cipher)
- Prompt chains for: audit diagnosis, keyword strategy, topic clusters, metadata, and content plans.
- Evaluation harness for quality scoring and hallucination checks.

---

## 4) Data Flow (Core User Journey)

1. **User submits URL** → `POST /api/projects/:id/audit/run`.
2. API enqueues `crawl_site` job.
3. Crawler stores pages + link graph + performance hints.
4. API enqueues `analyze_seo` AI job using crawled data.
5. AI writes findings to `seo_audits`, `keywords`, `topic_clusters`, `internal_links`.
6. UI streams progress and then renders score, issues, opportunities, and generation actions.
7. User triggers `programmatic page generation`; output stored in `programmatic_pages`.

---

## 5) Security & Compliance

- Supabase Auth (JWT) + RLS across all tenant tables.
- Secrets managed in platform env vars; never expose provider keys in client.
- PII minimization: only store contact/account and website content snapshots needed for SEO.
- Rate limits on high-cost endpoints (crawl and LLM generation).

---

## 6) Performance Targets (Initial SLOs)

- Dashboard TTI < 2.5s on broadband for cached projects.
- Crawl queue start latency < 30s p95.
- First-pass audit completion:
  - < 500 pages: 3–10 min
  - 500–5000 pages: 10–45 min
- API error rate < 1% p95.

---

## 7) Future Extensions

- Google Search Console and GA4 ingestion.
- A/B testing for generated meta titles and pages.
- Autonomous weekly “growth sprints” with auto-published drafts.
