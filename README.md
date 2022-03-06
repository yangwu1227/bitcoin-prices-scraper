# Flat Bitcoin Prices

This repository uses a [Flat Data GitHub Action](https://next.github.com/projects/flat-data/) to fetch the current price of Bitcoin from this [link](https://api.coindesk.com/v2/bpi/currentprice.json) and downloads that data to `btc-price.json` before filtering the data to create `btc-price-postprocessed.json`. Both files are updated at 12:00 p.m. (noon) every day if there are changes. 

## Flat Viewer

To view the Bitcoin prices, use the following [GUI](https://flatgithub.com/YangWu1227/flat-bitcoin-price).

# Credit

A detailed walk-through of the steps for building this 'git scrapper' can be found [here](https://github.com/githubocto/flat-demo-bitcoin-price). The 'git scraper' approach was originated by [Simon Willison](https://simonwillison.net/2020/Oct/9/git-scraping/).
