# Align Smart Contracts

Implementing the Align Protocol

[Spec](https://github.com/AlignNetwork/protocol)

### Contracts:

| Name               | Address                                    | abi                                 | network          | version |
| ------------------ | ------------------------------------------ | ----------------------------------- | ---------------- | ------- |
| AlignIdRegistry    | 0xD821932b7d8F2DE2e53845E4b8ab66aD661cA130 | [abi](/abi/AlignIdRegistry.json)    | Align Testnet v2 | v1.0.0  |
| VerifyIPFS         | 0x16BB489abDCE7f194052Dd3097DBB0DBE2d1F805 | [abi](/abi/VerifyIPFS.json)         | Align Testnet v2 | v0.0.0  |
| InteractionStation | 0xf581E6dfA593346E9c8163dD3Ed533ba9733A97a | [abi](/abi/InteractionStation.json) | Align Testnet v2 | v1.0.0  |

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

### To Test

`forge test --via-ir --watch -vvv`

### Coverage

`forge coverage --ir-minimum`
