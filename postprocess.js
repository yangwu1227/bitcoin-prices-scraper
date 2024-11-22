import {
    readJSON,
    writeJSON,
    removeFile
} from 'https://deno.land/x/flat@0.0.14/mod.ts';

/**
 * Reads a JSON file and returns its content.
 * @param {string} filename - The path to the JSON file.
 * @returns {Promise<Object>} - Parsed JSON data.
 */
async function readData(filename) {
    try {
        return await readJSON(filename);
    } catch (error) {
        console.error(`Failed to read file ${filename}:`, error.message);
        throw error;
    }
}

/**
 * Writes processed data to a new JSON file.
 * @param {string} filename - The name of the new JSON file.
 * @param {Array} data - The data to write.
 */
async function writeProcessedData(filename, data) {
    try {
        await writeJSON(filename, data);
        console.log(`Data successfully written to ${filename}`);
    } catch (error) {
        console.error(`Failed to write file ${filename}:`, error.message);
        throw error;
    }
}

/**
 * Deletes the specified file.
 * @param {string} filename - The file to delete.
 */
async function deleteFile(filename) {
    try {
        await removeFile(filename);
        console.log(`Deleted file: ${filename}`);
    } catch (error) {
        console.error(`Failed to delete file ${filename}:`, error.message);
        throw error;
    }
}

/**
 * Processes Bitcoin price data to extract relevant information.
 * @param {Object} data - The JSON data object.
 * @returns {Array} - Filtered array of currency rates.
 */
function processCurrencyRates(data) {
    if (!data?.bpi) {
        throw new Error("Invalid data format: 'bpi' property is missing.");
    }

    return Object.values(data.bpi).map(rate => ({
        currency: rate.description,
        bitcoinRate: rate.rate,
    }));
}

async function main() {

    // Extract filename from command-line arguments
    const filename = Deno.args[0];
    const outputFilename = 'btc-price-postprocessed.json';

    try {
        // Step 1: Read JSON data
        const rawData = await readData(filename);

        // Step 2: Process data
        const processedData = processCurrencyRates(rawData);

        // Step 3: Write processed data
        await writeProcessedData(outputFilename, processedData);

        // Step 4: Delete raw data file
        await deleteFile(filename);
    } catch (error) {
        console.error("Error during execution:", error.message);
        Deno.exit(1);
    }
}

if (import.meta.main) {
    await main();
}
