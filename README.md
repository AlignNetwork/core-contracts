# Align Smart Contracts

Implementing the Align Protocol

[Spec](https://github.com/AlignNetwork/protocol)

### Create a new Interaction Type

When creating a new interaction type you must define the JSON file and upload it to the IPFS compatible Align Data
Network. Once uploaded use it in a script to register the type.

#### Steps

This will create a non fungible, private type for you to interact with.

1. Get testnet sepolia ethereum for Align Testnet: [Bridge](https://align.network/bridge)
2. Mint an Align Id from [Mint](https://mint.align.network), if youre a interested developer or researcher, reach out to
   [@0xglu](http://twitter.com/0xglu) on twitter or in discord.
3. Create the interaction type (see [examples](/examples)) modify `DefaultInteractions` in `./deploy.sh`
4. run `chmod +x ./deploy.sh DefaultInteractions` - this will pin your file to the Data Network
5. Modify the script `./script/4200_MyInteraction.s.sol` (do not rename the script file or else step #5 will not work,
   you can modify the shell script in #5 if you'd like)
   1. line #17 - paste the hash from Step #4
6. ensure `RPC_URL` and `PRIVATE_KEY` are set in .env
7. run: `./deploy.sh MyInteraction`
8. The `interactionTypeKey` is now used to query using the public indexer at:[indexer link]()
