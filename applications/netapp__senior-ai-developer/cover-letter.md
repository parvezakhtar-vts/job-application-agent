Hi team,

NetApp's launch of AI Data Engine (AIDE), a single platform turning unstructured enterprise data into AI-ready pipelines, is exactly the kind of problem I've spent the last two years solving at production scale. As a Senior AI Developer with 5+ years in Python backend systems and production LLM deployments, I'd like to contribute to NetApp's path to $10B by building the AI services that make intelligent data infrastructure real for customers.

At Bigstep Technologies, I architected an **inference pipeline processing 2M+ records/month** via Python/FastAPI APIs. I built a Strategy Router that classifies each field's complexity and routes ~60% to deterministic parsers, reserving LLM calls for ambiguous cases only: this cut **token costs ~40%** while maintaining accuracy. Separately, I designed a **RAG pipeline** (SPLADE + Sentence-BERT + Cross-Encoder re-ranking) that lifted NDCG@5 by 15 points, and I operate these services end-to-end with OpenTelemetry tracing, metrics, and alerting.

Earlier, as Founding Engineer at Kuttl, I built a distributed data ingestion pipeline on **FastAPI + Temporal.io** handling 50k+ daily messages with full observability. I fine-tuned Llama-3 to replace GPT-4 for structured extraction, **cutting inference costs by 90%**, and applied semantic caching and request batching to improve P99 latency by 40% under load. At Amazon, I owned microservices at **99.99% availability** for 3,000+ merchants, optimized ECS/Docker infrastructure costs by $100k/year, and built testing frameworks (unit, integration, load) with CloudWatch alarms that caught N+1 bottlenecks before release.

NetApp's emphasis on reliability, scale, and cost efficiency in AI services maps directly to what I do daily: design Python APIs, integrate LLMs and RAG into production, profile performance, and operate with clear observability. I'd welcome the chance to discuss how I can help ship these capabilities for AIDE and beyond.

Best,
Parvez Akhtar
parvezakhtar218@gmail.com | +91 888-232-7732
