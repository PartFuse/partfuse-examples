import { fetchWithRetry, config } from './client.js';

const query = process.argv[2] || 'LM7805';

console.log(`Searching for: ${query}...`);

async function run() {
    try {
        const url = `${config.baseUrl}/api/v1/search?q=${encodeURIComponent(query)}&limit=5`;
        const data = await fetchWithRetry(url);
        console.log(JSON.stringify(data, null, 2));
    } catch (error) {
        console.error("Failed to search:", error.message);
    }
}

run();
