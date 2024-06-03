# Align Smart Contracts

Implementing the Align Protocol

[Spec](https://github.com/AlignNetwork/protocol)

### Contracts:

| Name               | Address                                    | abi                                 | network             | version |
| ------------------ | ------------------------------------------ | ----------------------------------- | ------------------- | ------- |
| AlignIdRegistry    | 0xaE57e1B93DA10a7B5e746B2d17B0b3c7D90B2dDa | [abi](/abi/AlignIdRegistry.json)    | Arbitrum Sepolia    | v1.0.0  |
| VerifyIPFS         | 0x3298154306f25E98efD779a8DCEB1322C4073345 | [abi](/abi/VerifyIPFS.json)         | Arbitrum Sepolia    | v1.0.0  |
| InteractionStation | 0xEe8710c0B14155541E151783A8C76422d0d5a676 | [abi](/abi/InteractionStation.json) | Arbitrum Sepolia v2 | v1.0.0  |

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

| File                               | % Lines         | % Statements     | % Branches     | % Funcs        |
| ---------------------------------- | --------------- | ---------------- | -------------- | -------------- |
| script/00_AlignIdRegistry.s.sol    | 0.00% (0/2)     | 0.00% (0/2)      | 100.00% (0/0)  | 0.00% (0/1)    |
| script/01_VerifyIPFS.s.sol         | 0.00% (0/1)     | 0.00% (0/1)      | 100.00% (0/0)  | 0.00% (0/1)    |
| script/02_InteractionStation.s.sol | 0.00% (0/3)     | 0.00% (0/5)      | 100.00% (0/0)  | 0.00% (0/1)    |
| script/03_CreateInteractions.s.sol | 0.00% (0/26)    | 0.00% (0/33)     | 100.00% (0/0)  | 0.00% (0/1)    |
| script/4200_MyInteraction.s.sol    | 0.00% (0/5)     | 0.00% (0/6)      | 100.00% (0/0)  | 0.00% (0/1)    |
| script/Base.s.sol                  | 0.00% (0/7)     | 0.00% (0/9)      | 0.00% (0/2)    | 0.00% (0/2)    |
| src/AlignIdRegistry.sol            | 100.00% (39/39) | 97.87% (46/47)   | 88.46% (23/26) | 100.00% (9/9)  |
| src/InteractionStation.sol         | 74.47% (35/47)  | 67.14% (47/70)   | 53.85% (14/26) | 63.64% (7/11)  |
| src/VerifyIPFS.sol                 | 80.00% (8/10)   | 85.71% (12/14)   | 83.33% (5/6)   | 100.00% (2/2)  |
| src/auth/Ownable.sol               | 5.56% (1/18)    | 5.88% (1/17)     | 0.00% (0/8)    | 30.77% (4/13)  |
| src/auth/OwnableRoles.sol          | 15.79% (3/19)   | 15.79% (3/19)    | 0.00% (0/6)    | 27.78% (5/18)  |
| Total                              | 48.59% (86/177) | 48.88% (109/223) | 56.76% (42/74) | 45.00% (27/60) |
