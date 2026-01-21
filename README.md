# PartFuse Examples

**Stop writing and maintaining 3 different distributor integrations.**  
PartFuse gives you pricing & stock for electronic components (Mouser, DigiKey, TME) through one clean API.

[![PartFuse on RapidAPI](https://img.shields.io/badge/RapidAPI-PartFuse-blue)](https://rapidapi.com/krystofcelba-jjINWODhz/api/partfuse)

> **Unified Electronic Components Pricing & Stock API**
>
> Connect to the PartFuse API to search and compare electronic component prices and stock from major distributors (TME, Mouser, DigiKey) in one unified interface.

[**Get your API Key on RapidAPI**](https://rapidapi.com/krystofcelba-jjINWODhz/api/partfuse)

---

## ⚡ Verified in 10 Seconds

Run this to see it working immediately (replace `YOUR_KEY`):

```bash
curl -s "https://partfuse.p.rapidapi.com/ping" \
  -H "X-RapidAPI-Key: YOUR_RAPIDAPI_KEY" \
  -H "X-RapidAPI-Host: partfuse.p.rapidapi.com"
```

---

## 🚀 Quickstart

1.  **Get your API Key** from [RapidAPI](https://rapidapi.com/krystofcelba-jjINWODhz/api/partfuse).
2.  **Clone this repository**:
    ```bash
    git clone https://github.com/PartFuse/partfuse-examples.git
    cd partfuse-examples
    ```
3.  **Choose your language** and follow the instructions in the respective folder:

| Language | Folder | Description |
| :--- | :--- | :--- |
| **Shell** | [`/curl`](./curl) | Simple `curl` scripts for quick testing. |
| **Python** | [`/python`](./python) | Sync (`requests`) and Async (`httpx`) examples with retries. |
| **Node.js** | [`/node`](./node) | Examples using `fetch` and `axios`. |
| **Go** | [`/go`](./go) | A simple CLI tool written in Go. |
| **Postman** | [`/postman`](./postman) | Collection and environment for Postman. |

---

## 🔑 Authentication

PartFuse is hosted on **RapidAPI**. You must include the following headers in every request:

```http
X-RapidAPI-Key: YOUR_RAPIDAPI_KEY
X-RapidAPI-Host: partfuse.p.rapidapi.com
```

### Environment Variables

All examples in this repository use the following environment variables. Copy the `.env.example` file in the respective language folder to `.env` and fill in your key.

```bash
# Required
PARTFUSE_RAPIDAPI_KEY=your_actual_api_key_here

# Optional (defaults used if not provided)
PARTFUSE_RAPIDAPI_HOST=partfuse.p.rapidapi.com
PARTFUSE_BASE_URL=https://partfuse.p.rapidapi.com
```

---

## 🔗 Endpoints

**Base URL**: `https://partfuse.p.rapidapi.com`

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/ping` | Liveness probe. Returns 200 OK immediately (no upstream checks). |
| `GET` | `/health` | Health check of internal services and suppliers. |
| `GET` | `/api/v1/search` | Search for parts. Params: `q` (query), `qty` (default 1), `limit` (default 10). |
| `GET` | `/api/v1/compare/{part_number}` | Get real-time pricing & stock. Params: `qty` (default 1). |
| `POST` | `/api/v1/bom/compare` | Bulk pricing for multiple parts. Body: JSON BOM. |

---

## 📡 API Best Practices

### Error Handling & Quotas
- **429 Too Many Requests**: You have exceeded a limit. This limit can be reached in two ways:
  - **RapidAPI Plan Limit**: You hit the daily/monthly request cap of your subscribed tier.
  - **Internal Monthly Credits**: You exhausted the internal usage credits allocated to your specific API key.
  
  **Advice**: Rate limits are strict. You should implement exponential backoff with jitter and always respect the `Retry-After` header if provided.

- **Partial Results**: The `offers` list may contain statuses like `supplier_unavailable` or `timeout`. Your application should handle these gracefully (e.g., "Supplier X unavailable").

### Data Freshness
- **Caching**: Data is typically cached for **15–60 minutes**.
- **Currencies**: Responses may contain prices in different currencies. Always use the `currency` field provided in each offer object rather than assuming a default.

---

## 🚫 Use Case Limitations

PartFuse is **NOT** designed for:
- **Consumer browsing**: Do not use this as a backend for a general-purpose e-commerce browsing experience.
- **Checkout/Ordering**: This API provides *information* only. You cannot place orders through PartFuse.
- **Contractual SLA**: The service is best-effort.

---

## 💬 Support

Need help? Use the [Discussions tab on RapidAPI](https://rapidapi.com/krystofcelba-jjINWODhz/api/partfuse/discussions).

---

## ❓ FAQ

**Q: What happens if I exceed my quota?**
A: You will receive a `429 Too Many Requests` error. Check your usage in the [RapidAPI Dashboard](https://rapidapi.com/developer/dashboard).

**Q: How do I see my usage?**
A: Visit the [RapidAPI Developer Dashboard](https://rapidapi.com/developer/dashboard) to track your API calls and remaining quota.

**Q: A supplier returned "timeout". What does that mean?**
A: It means the upstream supplier API did not respond within our timeout window. This happens occasionally; you can try the request again later.

---

## 📄 License

This repository is licensed under the **MIT License**.

**Disclaimer**: This project allows access to third-party data. Data accuracy is best-effort and not guaranteed. No purchasing capabilities are provided.
