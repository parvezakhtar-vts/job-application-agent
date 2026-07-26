Hi team,

I build the intelligence layer that turns messy, high-volume data into reliable AI, and doing that for security telemetry is a problem I would be glad to own. SonicWall is pushing AI deep into threat triage, behavioral detection, and remediation guidance, exactly the kind of work where model outputs have to be safe, deterministic, and accurate, not just plausible. That reliability bar is where I do my best work.

As Lead Architect at Bigstep Technologies, I set technical direction for production GenAI in small teams. I built a **serverless multi-agent** framework with **tool/function calling** over **MCP** for automated analysis and recommendations, cutting idle compute to a pay-per-execution model that saves **~$45k/year**. I also architected a **Field-Aware Extraction Engine** processing **2M+ records/month** that parses and reasons over unstructured records, where a routing layer sends ~60% of fields to deterministic parsers and reserves the LLM for the rest, trimming token spend **~40%** with no accuracy loss.

Trust and evaluation are built into how I ship. On the VTS document-intelligence pipeline I enforced **structured-output validation**, diagnosed a **10-point accuracy regression**, and recovered the full drop back to an **~88% baseline**. At Kuttl I ran **RAGAS** evaluation gates in CI/CD that block any deployment below threshold, fine-tuned **Llama-3-8B** with LoRA to cut inference cost **90%**, and built **semantic search** and **hybrid retrieval** (with **Qdrant**-class vector stores) plus guardrails and prompt-injection defense. The MLOps is real too: **FastAPI** and **Temporal.io** pipelines on **Docker/Kubernetes** and AWS, handling **50k+ daily messages** with retries and dead-letter queues.

Cybersecurity is a domain where getting AI wrong has real cost, which is exactly why I want to build it here.

I would welcome the chance to discuss how I can contribute.

Best,
Parvez Akhtar
+91 888-232-7732 | parvezakhtar218@gmail.com
