# Align Smart Contracts

Implementing the Align Protocol

[Spec](https://github.com/AlignNetwork/protocol)

### Create a new Interaction Type

When creating a new interaction type you must define the JSON file and upload it to the IPFS compatible Align Data
Network. Once uploaded use it in a script to register the type.

#### Steps

This will create a non fungible, private type for you to interact with.

1. Get testnet sepolia ethereum for Align Testnet: [Bridge](https://align.network/bridge)
2. Create an Align Id by running the script `./bash/deploy.sh CreateAlignId`
3. Create the JSON in line #8 of `./createInteractionType.sh`
4. run `chmod +x ./createInteractionType.sh` and save the IPFS hash in the `data` field
5. Modify the script `./script/4200_MyInteraction.s.sol` (do not rename the script file or else step #5 will not work,
   you can modify the shell script in #5 if you'd like)
   1. line #20 - paste the hash from Step #4
6. ensure `RPC_URL` and `PRIVATE_KEY` are set in .env
7. run: `./deploy.sh UG`
8. The `interactionTypeKey` is now used to query using the public indexer at:[indexer link]()
