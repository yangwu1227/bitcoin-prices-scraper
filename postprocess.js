// Helper library written for useful postprocessing tasks with Flat Data
// Has helper functions for manipulating csv, json, excel, zip, and image files
import { readJSON, writeJSON } from 'https://deno.land/x/flat@0.0.11/mod.ts' 

// Step 1: Read the downloaded_filename JSON
// Same name as downloaded_filename `const filename = 'btc-price.json';`
const filename = Deno.args[0]
const json = await readJSON(filename)
console.log(json)

// Step 2: Filter specific data we want to keep and write to a new JSON file
// Convert property values into an array
const currencyRates = Object.values(json.bpi);
const filteredCurrencyRates = currencyRates.map(rate => ({ 
    currency: rate.description,
    bitcoinRate: rate.rate
}));

// Step 3. Write a new JSON file with our filtered data
// Name of a new file to be saved
const newFilename = `btc-price-postprocessed.json`
// Create a new JSON file with just the Bitcoin price
await writeJSON(newFilename, filteredCurrencyRates) 
console.log("Wrote a post process file")

// Delete raw data
await removeFile(filename)
