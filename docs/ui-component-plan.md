# UI/UX Component Plan (Maya + Jax)

## Design Language

- **Theme:** Dark mode first, neon-accented glassmorphism.
- **Visual treatment:** Frosted cards (`backdrop-blur-xl`, soft borders, subtle shadows).
- **Motion:** Framer Motion for micro-interactions (150–280ms range).
- **Density:** Data-dense but breathable spacing.

## Global Layout

- Left sidebar with project switcher and feature modules.
- Top bar: quick URL input, notifications, profile menu.
- Main area: page-specific widgets and data visualizations.

## Primary Pages and Components

### 1) Landing Page
- Hero with domain input CTA.
- Social proof logos + metric counters.
- Feature cards with animated hover states.

### 2) Dashboard
- `HealthScoreGauge`
- `AuditSummaryCards`
- `IssueSeverityBreakdown`
- `RecentJobTimeline`
- `QuickActionsPanel`

### 3) Website Audit Page
- `CrawlStatusBanner`
- `IssueTable` (filter/sort by severity/category)
- `PageDetailDrawer`
- `CoreWebVitalsMiniChart`

### 4) Keyword Research Page
- `KeywordTable`
- `IntentDistributionDonut`
- `KeywordOpportunityMatrix`

### 5) Topic Cluster Builder
- `PillarTopicCard`
- `ClusterTreeView`
- `ArticleBatchGeneratorPanel`

### 6) Programmatic SEO Generator
- `TemplatePresetGrid`
- `GenerationConfigForm`
- `GeneratedPagesDataGrid`
- `SchemaPreviewAccordion`

### 7) Internal Link Map
- `LinkGraphCanvas` (force-directed graph)
- `AuthorityFlowHeatmap`
- `AnchorSuggestionList`

### 8) SEO Report Page
- `ExecutiveSummaryCard`
- `RecommendationsRoadmap`
- `ExportButtons` (PDF/CSV/JSON)

## Interaction Principles

- Always show progress on long-running tasks with staged status.
- Display confidence scores for AI-generated suggestions.
- Enable one-click actions: “Apply metadata”, “Create cluster”, “Generate pages”.

## Accessibility

- WCAG AA contrast minimum.
- Keyboard support for all table/filter controls.
- Reduced-motion fallback for animated sections.
