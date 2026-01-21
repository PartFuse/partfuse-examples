import 'dotenv/config'; 
// dotenv/config automatically loads .env

const config = {
    apiKey: process.env.PARTFUSE_RAPIDAPI_KEY,
    host: process.env.PARTFUSE_RAPIDAPI_HOST || 'partfuse.p.rapidapi.com',
    baseUrl: process.env.PARTFUSE_BASE_URL || 'https://partfuse.p.rapidapi.com'
};

if (!config.apiKey) {
    console.error("Error: PARTFUSE_RAPIDAPI_KEY is not set in .env");
    process.exit(1);
}

const headers = {
    'X-RapidAPI-Key': config.apiKey,
    'X-RapidAPI-Host': config.host,
    'Content-Type': 'application/json'
};

/**
 * Basic fetch wrapper with retry logic for 429s.
 */
export async function fetchWithRetry(url, options = {}, retries = 3) {
    for (let i = 0; i < retries; i++) {
        try {
            const response = await fetch(url, { ...options, headers: { ...headers, ...options.headers } });
            
            if (response.status === 429) {
                const retryAfter = response.headers.get('Retry-After');
                const waitTime = retryAfter ? parseInt(retryAfter, 10) * 1000 : (i + 1) * 1000;
                console.log(`Rate limited. Waiting ${waitTime}ms...`);
                await new Promise(resolve => setTimeout(resolve, waitTime));
                continue;
            }

            if (!response.ok) {
                const body = await response.text();
                throw new Error(`API Error ${response.status}: ${body}`);
            }

            return await response.json();
        } catch (error) {
            if (i === retries - 1) throw error;
            console.warn(`Attempt ${i + 1} failed: ${error.message}. Retrying...`);
            await new Promise(resolve => setTimeout(resolve, (i + 1) * 1000));
        }
    }
}

export { config, headers };
