# Next.js App Router Folder Structure

```txt
src/
  app/
    (marketing)/
      page.tsx                     # Landing page
      pricing/page.tsx
    (dashboard)/
      layout.tsx                   # Authenticated app shell
      dashboard/page.tsx
      projects/[projectId]/
        page.tsx                   # Project overview
        audit/page.tsx
        keywords/page.tsx
        topic-clusters/page.tsx
        programmatic/page.tsx
        internal-links/page.tsx
        reports/page.tsx
    api/
      projects/route.ts
      projects/[projectId]/route.ts
      projects/[projectId]/audit/run/route.ts
      projects/[projectId]/jobs/route.ts
      projects/[projectId]/jobs/[jobId]/route.ts
      projects/[projectId]/audits/latest/route.ts
      projects/[projectId]/audits/[auditId]/issues/route.ts
      projects/[projectId]/keywords/route.ts
      projects/[projectId]/keywords/generate/route.ts
      projects/[projectId]/topic-clusters/route.ts
      projects/[projectId]/topic-clusters/generate/route.ts
      projects/[projectId]/programmatic-pages/route.ts
      projects/[projectId]/programmatic-pages/generate/route.ts
      projects/[projectId]/internal-links/graph/route.ts
      projects/[projectId]/internal-links/analyze/route.ts
      projects/[projectId]/metadata/optimize/route.ts
      projects/[projectId]/content/optimize/route.ts
  components/
    ui/                             # shadcn primitives
    layout/
      app-sidebar.tsx
      top-nav.tsx
    dashboard/
      kpi-card.tsx
      health-score-gauge.tsx
      issue-table.tsx
      crawl-progress.tsx
    audit/
      issue-severity-tabs.tsx
      page-health-table.tsx
    keywords/
      keyword-intent-chart.tsx
      keyword-table.tsx
    topic-clusters/
      pillar-cluster-tree.tsx
      article-plan-card.tsx
    programmatic/
      page-template-selector.tsx
      generated-page-table.tsx
    links/
      internal-link-graph.tsx
      anchor-opportunity-list.tsx
  lib/
    supabase/
      client.ts
      server.ts
    ai/
      openai.ts
      prompts.ts
      chains/
        audit-chain.ts
        keyword-chain.ts
        cluster-chain.ts
        metadata-chain.ts
        content-opt-chain.ts
    crawler/
      normalize-url.ts
      robots.ts
      sitemap.ts
    scoring/
      seo-health.ts
      issue-priority.ts
    validation/
      api-schemas.ts
  workers/
    crawl-worker.ts
    seo-analysis-worker.ts
    programmatic-worker.ts
  styles/
    globals.css
```

## Notes

- Keep expensive operations in workers and queue-triggered functions.
- Keep route handlers thin (auth + validation + enqueue).
- Prefer server components for data-heavy dashboard surfaces.
