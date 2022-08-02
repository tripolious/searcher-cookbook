# searcher cookbook
Follow me on [Twitter](https://twitter.com/tripolious) for updates  

The cookbook is a collection of usefully scripts, functions, smart contracts, helpers, tips and bots for golang searchers.

I will try to cover most of the topics you need to know as a searcher, so you can start your own journey.

## Contents:
- 01 - [server configuration](server-configuration) Minimum setup to start your own node server.  
- 02 - [eth_call with state override](eth_call-state-override) Use BatchCalls and eth_call with state overwrites. 
- 03 - [log information and update your program via discord](discord-usage) - Use discord to update configuration settings without restarting and also log data to discord
- 04 - **to be announced** - Use eth-logs to load pairs, tokens and updates from new blocks
- 05 - **to be announced** - Store pairs and their state in-memory and save it when you shut down or restart your program
- 06 - [on chain calculation](onchain-calculation) - Smart Contract to make an on chain calculation for uni2 and uni3 swaps
- 07 - **to be announced** - Gas and calldata optimized assembly contract for uni2 and uni3 swaps
- 08 - **to be announced** - Off-chain calculation for uni2 and uni3 swaps
- 09 - **to be announced** - Prepare pairs with possible trade-ways for faster look-ups and calculations
- 10 - **to be announced** - Use eth_callBundle locally for faster checks
- 11 - **to be announced** - How to use eth_sendBundle and flashbots_getBundleStats to check your bundle
- 12 - **to be announced** - Example to find best routes in your trade-ways

# Bonus
I will release packages I use in my bots or scripts that will help you in different areas
- [dexc](https://github.com/tripolious/dexc) - off-chain calculation for different DEXs
- [discogo](https://github.com/tripolious/discogo) - use discord to send special logs to your discord channel or consume messages in your program    
- [funcsig-search](https://github.com/tripolious/funcsig-search) - search for specific function signatures

### To be continued
After I finish the topics from above I will probably add more.  
Please let me know in what topics your interested the most.

### Why do you share all this information?
I know that most of the searchers keep their findings and learnings as a secrete and so it's hard for newcomers to get started.
Flashbots did a good job so far, and with this repo I hope I can contribute also a bit to it.