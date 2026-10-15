from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
import uvicorn

app = FastAPI(title="FindIt API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Models ──────────────────────────────────────────────────────────────────

class Product(BaseModel):
    id: str
    image_url: str
    title: str
    retailer: str
    price: float
    affiliate_url: str
    similarity_score: float

class Result(BaseModel):
    id: str
    instagram_post_url: str
    original_image_url: str
    detected_class: str
    matches: List[Product]
    processed_at: str

class SavedItem(BaseModel):
    id: str
    product: Product
    saved_at: str

class WebhookPayload(BaseModel):
    user_id: str
    instagram_username: str
    post_url: str
    media_url: str

# ── Mock Data ────────────────────────────────────────────────────────────────

MOCK_PRODUCTS = {
    "sofa": [
        Product(id="p1", image_url="https://picsum.photos/seed/sofa1/400/400", title="Cloud Modular Sofa — Cream Boucle", retailer="West Elm", price=1299.00, affiliate_url="https://westelm.com", similarity_score=0.97),
        Product(id="p2", image_url="https://picsum.photos/seed/sofa2/400/400", title="Haven Sectional — Stone Grey", retailer="Crate & Barrel", price=2199.00, affiliate_url="https://crateandbarrel.com", similarity_score=0.91),
        Product(id="p3", image_url="https://picsum.photos/seed/sofa3/400/400", title="Nomad Sofa — Natural Linen", retailer="Burrow", price=995.00, affiliate_url="https://burrow.com", similarity_score=0.88),
        Product(id="p4", image_url="https://picsum.photos/seed/sofa4/400/400", title="Slope Sofa — Charcoal", retailer="Article", price=849.00, affiliate_url="https://article.com", similarity_score=0.84),
    ],
    "top": [
        Product(id="p5", image_url="https://picsum.photos/seed/top1/400/400", title="Ribbed Knit Crop Top — Ivory", retailer="ASOS", price=34.99, affiliate_url="https://asos.com", similarity_score=0.95),
        Product(id="p6", image_url="https://picsum.photos/seed/top2/400/400", title="Linen Relaxed Shirt — Sage", retailer="& Other Stories", price=69.00, affiliate_url="https://stories.com", similarity_score=0.89),
        Product(id="p7", image_url="https://picsum.photos/seed/top3/400/400", title="Oversized Button-Down — Stripe", retailer="Zara", price=45.90, affiliate_url="https://zara.com", similarity_score=0.85),
        Product(id="p8", image_url="https://picsum.photos/seed/top4/400/400", title="Fitted Cami — Chocolate", retailer="H&M", price=19.99, affiliate_url="https://hm.com", similarity_score=0.81),
    ],
    "bag": [
        Product(id="p9", image_url="https://picsum.photos/seed/bag1/400/400", title="Mini Shoulder Bag — Tan Leather", retailer="Mango", price=89.99, affiliate_url="https://mango.com", similarity_score=0.96),
        Product(id="p10", image_url="https://picsum.photos/seed/bag2/400/400", title="Woven Tote — Natural", retailer="& Other Stories", price=125.00, affiliate_url="https://stories.com", similarity_score=0.90),
        Product(id="p11", image_url="https://picsum.photos/seed/bag3/400/400", title="Structured Top Handle — Black", retailer="Zara", price=59.90, affiliate_url="https://zara.com", similarity_score=0.86),
    ],
}

MOCK_RESULTS = [
    Result(
        id="r1",
        instagram_post_url="https://instagram.com/p/mock1",
        original_image_url="https://picsum.photos/seed/room1/800/800",
        detected_class="sofa",
        matches=MOCK_PRODUCTS["sofa"],
        processed_at="2026-02-22T10:30:00Z",
    ),
    Result(
        id="r2",
        instagram_post_url="https://instagram.com/p/mock2",
        original_image_url="https://picsum.photos/seed/outfit1/800/800",
        detected_class="top",
        matches=MOCK_PRODUCTS["top"],
        processed_at="2026-02-22T09:15:00Z",
    ),
    Result(
        id="r3",
        instagram_post_url="https://instagram.com/p/mock3",
        original_image_url="https://picsum.photos/seed/street1/800/800",
        detected_class="bag",
        matches=MOCK_PRODUCTS["bag"],
        processed_at="2026-02-21T18:45:00Z",
    ),
]

MOCK_SAVED = [
    SavedItem(id="s1", product=MOCK_PRODUCTS["sofa"][0], saved_at="2026-02-22T11:00:00Z"),
    SavedItem(id="s2", product=MOCK_PRODUCTS["top"][1], saved_at="2026-02-21T20:00:00Z"),
]

# ── Routes ───────────────────────────────────────────────────────────────────

@app.post("/webhook")
async def receive_webhook(payload: WebhookPayload):
    """Instagram webhook — mention or DM received."""
    # In production: validate Instagram signature, queue pipeline job
    return {"status": "received", "job_id": "mock_job_123"}

@app.get("/results/{user_id}", response_model=List[Result])
async def get_results(user_id: str):
    """All processed results for a user."""
    return MOCK_RESULTS

@app.get("/result/{result_id}", response_model=Result)
async def get_result(result_id: str):
    """Single result by ID."""
    result = next((r for r in MOCK_RESULTS if r.id == result_id), None)
    if not result:
        raise HTTPException(status_code=404, detail="Result not found")
    return result

@app.get("/product/{product_id}", response_model=Product)
async def get_product(product_id: str):
    """Single product detail."""
    all_products = [p for prods in MOCK_PRODUCTS.values() for p in prods]
    product = next((p for p in all_products if p.id == product_id), None)
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

@app.post("/save/{user_id}/{product_id}")
async def save_product(user_id: str, product_id: str):
    """Save a product to wishlist."""
    return {"status": "saved", "product_id": product_id}

@app.delete("/save/{user_id}/{product_id}")
async def unsave_product(user_id: str, product_id: str):
    """Remove product from wishlist."""
    return {"status": "removed", "product_id": product_id}

@app.get("/saved/{user_id}", response_model=List[SavedItem])
async def get_saved(user_id: str):
    """User's saved/wishlist items."""
    return MOCK_SAVED

@app.get("/health")
async def health():
    return {"status": "ok", "timestamp": datetime.utcnow().isoformat()}

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
