#!/bin/bash
sleep 5

# Send a minimal prompt to fully warm up and prime the 9B model into VRAM
curl -s http://localhost:11434/api/generate -d '{
  "model": "qwen3.8-9b-distill-agent:latest",
  "prompt": "ping",
  "stream": false,
  "keep_alive": -1,
  "options": {"num_ctx": 16384}
}' > /dev/null

echo "Distillation model primed and locked into VRAM."
