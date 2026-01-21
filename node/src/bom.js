import { fetchWithRetry, config } from './client.js';
import fs from 'fs/promises';
import path from 'path';

console.log("Running BOM comparison...");

async function run() {
    try {
        // Read bom.json
        const bomPath = path.resolve('bom.json');
        let bomData;
        try {
            const content = await fs.readFile(bomPath, 'utf-8');
            bomData = JSON.parse(content);
        } catch (e) {
            console.warn("Could not read bom.json, using sample data.");
            bomData = {
                lines: [
                    { mpn: "NE555", quantity: 50, reference: "U1" },
                    { mpn: "10k Resistor", quantity: 100 }
                ]
            };
        }

        const url = `${config.baseUrl}/api/v1/bom/compare`;
        const data = await fetchWithRetry(url, {
            method: 'POST',
            body: JSON.stringify(bomData)
        });

        console.log(JSON.stringify(data, null, 2));

    } catch (error) {
        console.error("BOM Error:", error.message);
    }
}

run();
