import { fetchWithRetry, config } from './client.js';
import axios from 'axios';

// Demonstrating AXIOS usage here for variety
const partNumber = process.argv[2] || 'STM32F103C8T6';
const qty = process.argv[3] || 1;

console.log(`Comparing prices for: ${partNumber} (using Axios)...`);

async function run() {
    try {
        const url = `${config.baseUrl}/api/v1/compare/${encodeURIComponent(partNumber)}`;
        
        // Axios config
        const axiosConfig = {
            headers: {
                'X-RapidAPI-Key': config.apiKey,
                'X-RapidAPI-Host': config.host
            },
            params: { qty }
        };

        const response = await axios.get(url, axiosConfig);
        console.log(JSON.stringify(response.data, null, 2));

    } catch (error) {
        if (error.response) {
            console.error(`API Error ${error.response.status}:`, error.response.data);
        } else {
            console.error("Network Error:", error.message);
        }
    }
}

run();
