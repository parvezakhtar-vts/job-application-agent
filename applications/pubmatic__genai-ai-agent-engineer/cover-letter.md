Hi team,

I build AI agents that survive production, and PubMatic is doing that at a scale few teams reach. AgenticOS and your work co-founding AdCP, an open protocol for agent-to-agent communication in advertising, sit right on top of the patterns I work in every day: multi-agent orchestration, tool-use over shared protocols, and reliability under real load. I would like to build that next layer with you.

As Lead Architect at Bigstep Technologies, I built a **serverless multi-agent** framework for Salesforce automation with **tool/function calling**, multi-step planning, and agent memory over **MCP (Model Context Protocol)**, cutting idle compute to a pay-per-execution model that saves **~$45k/year**. Because AdCP is a close cousin of MCP, that experience transfers directly. I also architected a Field-Aware Extraction Engine processing **2M+ records/month**, where a routing layer sends ~60% of fields to deterministic parsers and reserves the LLM for the rest, trimming token spend **~40%** with no accuracy loss. That cost discipline is the same instinct behind processing more impressions for less that PubMatic writes about.

On the retrieval and model side, I built a **hybrid search** pipeline (SPLADE plus dense vectors, fused with Reciprocal Rank Fusion and cross-encoder re-ranking) that lifted **NDCG@5 from 0.71 to 0.86**, and I fine-tuned **Llama-3-8B** with LoRA to replace GPT-4, hitting **98% schema compliance** at **90% lower** inference cost. I keep these systems honest with **RAGAS** evaluation gates in CI/CD and **Langfuse** tracing, so quality regressions get caught before release, not after.

What draws me to PubMatic is the ambition of agentic advertising as an engineering problem: real-time, high-stakes, and cost-sensitive. That is exactly the kind of system I like to make reliable.

I would welcome the chance to discuss how I can contribute.

Best,
Parvez Akhtar
+91 888-232-7732 | parvezakhtar218@gmail.com
