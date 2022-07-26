# searcher cookbook
Follow on [twitter](https://twitter.com/tripolious) for updates  

The cookbook is a collection of usefully scripts, functions, smart contracts, helpers, tips and bots for golang searchers.

I will try to cover most of the topics you need to know as a searcher.  
Don't expect the bots I will share over time to make you rich, as I will only start sharing older versions of it.  
Still, if you follow up and understand the basics I'm pretty sure you will find your own alpha.

All in all you need to love competitive games to stay up with all the excellent searchers out there.

# Contents:
- 01 - [server configuration](server-configuration/README.md) Node set up on your server.  
- 02 - [eth_call with state override](eth_call-state-override/README.md) Example usage for BatchCalls and eth_call with state overwrites. We will use this later for faster initialization and reboots for your bot.
- 03 - [log information and update your program via discord](discord-usage/README.md) - Example usage to use discord to update your bot without restarting and also log data you will use to debug your bundles
- 04 - **to be announced** - Example usage of logs to load and prepare pairs and tokens
- 05 - **to be announced** - cache in-memory your pairs and save it when you shut down your bot
- 06 - [on chain calculation](onchain-calculation/README.md) - Smart Contract to make an on chain calculation for uni2 and uni3 pairs
- 07 - **to be announced** - Smart Contracts without flashswaps
  - 07.1 - **to be announced** - uni2-swaps assembly contract 
  - 07.2 - **to be announced** - add uni3-swaps
- 08 - **to be announced** - Smart Contracts with flashswaps
  - 08.1 - **to be announced** - uni2-flashswaps assembly contract
  - 08.2 - **to be announced** - add uni3-flashswaps
- 09 - **to be announced** - Example to make offchain calculations for uni2 and uni3
- 10 - **to be announced** - Order pairs for trade-ways and save to in-memory cache
- 11 - **to be announced** - Example to use eth_callBundle, eth_sendBundle and flashbots_getBundleStats
- 12 - **to be announced** - Example to find best routes in your trade-ways
- 13 - **to be announced** - Put everything together for your first bot

# Bonus
I will release packages I use in my bots or scripts that will help you in different areas
- [discogo](https://github.com/tripolious/discogo) - used for sending special logs to my discord channel and update different configurations like miner fee % without restarting the bot or check flashbots_getBundleStats directly from discord.    
- [funcsig-search](https://github.com/tripolious/funcsig-search) - search for specific function signatures

### To be continued
After I finished the topics from above I will probably start sharing some other strats and bots.  
Please let me know in what topics your interested the most.

### Why do you share all this information?
I know that most of the searchers keep their findings and learnings as a secrete, still I think we need more devs in the market to push crypto.    
As a searcher you will get in touch and need to learn nearly everything about crypto.  
Flashbots did an amazing job, and so I want to contribute back.