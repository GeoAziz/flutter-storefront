# Phase 1 Kanban Board

> This file tracks Phase 1 tasks for the e-commerce app.  
> Columns represent progress stages. Move tasks manually as they progress.

---

## 📝 Backlog
- Future UX polish & accessibility enhancements
- Additional widget & unit tests
- Marketplace support (multi-seller) 
- Analytics & crash reporting setup
- Localization / Intl setup

---

## ✅ Ready / Aligned
| Task | Labels | Size | Assignee |
|------|--------|------|----------|
| Harden CI & Analyzer | infra, critical, tests | S | [Dev Mate] |
| Route Name Standardization | infra, critical | S | [Dev Mate] |
| ProviderScope Wiring & ProductRepository Toggle | backend, infra | S | [Dev Mate] |
| Cart Provider & Local Persistence | backend, enhancement | M | [Dev Mate] |
| Complete Home & Product Screens Provider Wiring | backend, product | M | [Dev Mate] |
| Checkout Skeleton & Payment Adapter | backend, enhancement | M | [Dev Mate] |
| Add End-to-End Smoke Tests | tests, critical | M | [Dev Mate] |
| Backend Contract: Products API | backend, critical | S | [Dev Mate] |

---

## 🏗 In Progress
- Move tasks here when work starts.

---

## 🔍 In Review / QA
- Tasks waiting for PR review or QA testing.

---

## ✅ Done
- Completed tasks go here after PR merge and verification.

---

### ⚡ Labels Guide
- **infra** → CI/CD, build config, route fixes  
- **product** → UI/UX work  
- **backend** → API integration, state management  
- **enhancement** → polishing, optimizations  
- **ui** → visual components  
- **tests** → unit/widget/e2e tests  
- **critical** → blockers for Phase 1 MVP  
- **design** → branding / visual assets  

---

### 📌 Notes
- This file is a **manual representation** of the Kanban board.
- Update this file as tasks move through stages to **keep the team aligned**.
- PRs should link to issues/tasks for automatic updates where possible.
