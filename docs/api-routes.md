# API Routes (Next.js App Router + Supabase)

Base path: `/api`

## Auth & Projects

- `POST /api/projects`
  - Create project from domain URL.
- `GET /api/projects`
  - List user projects.
- `GET /api/projects/:projectId`
  - Get project details and last run summary.
- `PATCH /api/projects/:projectId`
  - Update name/settings.
- `DELETE /api/projects/:projectId`
  - Archive/remove project and child data.

## Crawl & Audit Jobs

- `POST /api/projects/:projectId/audit/run`
  - Queue crawl + SEO audit job.
  - Body: `{ maxPages?: number, recrawl?: boolean }`
- `GET /api/projects/:projectId/jobs`
  - List jobs for project.
- `GET /api/projects/:projectId/jobs/:jobId`
  - Poll job progress and output.
- `POST /api/projects/:projectId/jobs/:jobId/cancel`
  - Cancel queued/running job.

## SEO Audit Results

- `GET /api/projects/:projectId/audits/latest`
  - Get latest audit summary and score.
- `GET /api/projects/:projectId/audits/:auditId/issues`
  - Paginated issue list (`severity`, `category`, `page` filters).
- `GET /api/projects/:projectId/pages`
  - Crawled pages with technical SEO attributes.

## Keyword Research

- `POST /api/projects/:projectId/keywords/generate`
  - Generate primary/secondary/long-tail/question/semantic keywords.
- `GET /api/projects/:projectId/keywords`
  - List generated keywords.
- `PATCH /api/projects/:projectId/keywords/:keywordId`
  - Update targeting or priority.

## Topical Authority Builder

- `POST /api/projects/:projectId/topic-clusters/generate`
  - Generate pillar + cluster structure.
- `GET /api/projects/:projectId/topic-clusters`
  - List clusters.
- `GET /api/projects/:projectId/topic-clusters/:clusterId`
  - Cluster detail + suggested articles.

## Programmatic SEO Pages

- `POST /api/projects/:projectId/programmatic-pages/generate`
  - Generate 100–500 draft pages from templates.
- `GET /api/projects/:projectId/programmatic-pages`
  - List generated pages.
- `PATCH /api/projects/:projectId/programmatic-pages/:pageId`
  - Edit title/meta/outline/status.
- `POST /api/projects/:projectId/programmatic-pages/export`
  - Export JSON/CSV/MD bundle for CMS import.

## Internal Linking Map

- `POST /api/projects/:projectId/internal-links/analyze`
  - Analyze and score link opportunities.
- `GET /api/projects/:projectId/internal-links/graph`
  - Return node/edge structure for visualization.

## Content Gap Analysis

- `POST /api/projects/:projectId/content-gap/analyze`
  - Body includes competitor domains.
- `GET /api/projects/:projectId/content-gap/latest`
  - Retrieve latest gap report.

## Metadata Optimization & Content Optimization

- `POST /api/projects/:projectId/metadata/optimize`
  - Generate title/meta/OG/Twitter/schema for selected URLs.
- `POST /api/projects/:projectId/content/optimize`
  - Improve selected page content and structure.

## Webhooks / Integrations (optional)

- `POST /api/integrations/webhooks/publish`
  - Push generated pages to CMS pipeline.

## Edge Function Suggestions

- `crawl-site`: performs crawling and page extraction.
- `analyze-seo`: runs LLM scoring and issue classification.
- `generate-keywords`: AI keyword and intent generation.
- `generate-programmatic-pages`: page drafts + schema.
- `analyze-internal-links`: authority flow + anchors.
