Hi team,

I have spent the last two years building the unglamorous parts of AI agents that the demo never shows: keeping context coherent across large inputs, choosing the right model per task, and catching regressions before users do. Turning natural language into production-ready full-stack apps is exactly that problem at the hardest setting, and it is the one I want to work on at Bolt.new.

At VTS, I built an **agentic document-intelligence pipeline** that abstracts structured terms from commercial real-estate leases with **structured-output validation**. When field-level accuracy dropped **10 points**, I treated it as a data problem: I **analyzed failure modes** across multi-turn extraction, then redesigned the prompt strategy and image preprocessing to recover the full drop and restore the **~88% baseline**. That loop of measure, diagnose, and iterate is how I think agents get reliable.

Context and cost are the other half. On a GenAI platform processing **2M+ records/month**, I built a **Strategy Router** that classifies each field by complexity and routes about **60%** to deterministic parsers, reserving the LLM for the rest and **cutting token spend ~40%** with no measurable accuracy loss. I have orchestrated **multi-step, multi-agent workflows** with **tool/function calling over MCP**, and built **CI evaluation gates (RAGAS)** that block deploys when faithfulness or answer-relevancy slips. I also choose models on evidence: I **fine-tuned Llama-3-8B to replace GPT-4** for a structured task, holding **98% schema compliance** while **cutting per-token cost 90%**.

What pulls me to Bolt is the pace and the stakes: an agent shipping to millions, where **context management** and **tool orchestration** are the product, not a feature. I work daily across **Python and TypeScript** and like owning problems end to end. I would love to help push what these agents can reliably build.

Best,
Parvez Akhtar
+91 888-232-7732 | parvezakhtar218@gmail.com
