from fastapi import FastAPI
app = FastAPI(title="WebRover Test API 🚀")

@app.get("/")
async def root():
    return {"status": "WebRover API работает!", "endpoints": ["/docs", "/health"]}

@app.get("/health")
async def health():
    return {"status": "healthy", "gpu": "disabled"}

@app.get("/docs")
async def docs():
    return {"docs": "Swagger UI готов!", "url": "/docs"}
