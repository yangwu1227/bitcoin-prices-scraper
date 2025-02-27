import { writeJSON } from 'https://deno.land/x/flat@0.0.15/mod.ts';

/**
 * Fetches Bitcoin current price data from CoinGecko.
 * Uses the simple price endpoint for multiple currencies.
 * @returns {Promise<Object>} - The JSON data returned by the API.
 */
async function fetchBitcoinPrice() {
    const url = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd,gbp,eur,cny';
    const response = await fetch(url);
    if (!response.ok) {
        throw new Error(`Failed to fetch data: ${response.statusText}`);
    }
    return await response.json();
}

/**
 * Formats the raw API data into an array of objects.
 * Each object contains a full currency name (in snake_case) and
 * the corresponding Bitcoin rate formatted with comma separators.
 *
 * @param {Object} data - The raw data from the API.
 * @returns {Array} - An array of formatted currency rate objects.
 */
function formatRates(data) {
    if (!data?.bitcoin) {
        throw new Error("Invalid data format: 'bitcoin' property is missing");
    }

    // Mapping from short currency codes to full snake_case names
    const currencyMap = {
        usd: 'united_states_dollar',
        gbp: 'british_pound_sterling',
        eur: 'euro',
        cny: 'chinese_yuan',
    };

    const result = [];

    // Iterate over each currency in the bitcoin data
    for (const [code, rate] of Object.entries(data.bitcoin)) {
        if (currencyMap[code]) {
            result.push({
                currency: currencyMap[code],
                // Format the number with comma as thousands separator
                bitcoin_rate: rate.toLocaleString('en-US', { maximumFractionDigits: 3 }),
            });
        }
    }
    return result;
}

async function main() {
    const outputFilename = 'btc-price-postporcesesd.json';
    try {
        // Step 1: Fetch data from CoinGecko api
        const rawData = await fetchBitcoinPrice();

        // Step 2: Format the data
        const processedData = formatRates(rawData);

        // Step 3: Write processed data to a file
        await writeJSON(outputFilename, processedData);
        console.log(`Data successfully written to ${outputFilename}`);
    } catch (error) {
        console.error('Error during execution:', error.message);
        Deno.exit(1);
    }
}

if (import.meta.main) {
    await main();
}
