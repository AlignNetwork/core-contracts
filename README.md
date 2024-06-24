# Align Smart Contracts

### Contracts:

| Name               | Address                                                                                                                                   | abi                                 | network           | version |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------- | ----------------- | ------- |
| AlignIdRegistry    | [0x169610100A7A25CF154C26b1A811FEf8592b27A8](https://optimistic.etherscan.io/address/0x169610100A7A25CF154C26b1A811FEf8592b27A8)          | [abi](/abi/AlignIdRegistry.json)    | Optimisim         | v1.0.0  |
| InteractionStation | [0xBb03fabb5709B52eC483314c964a187Bf447E508](https://optimistic.etherscan.io/address/0xBb03fabb5709B52eC483314c964a187Bf447E508)          | [abi](/abi/InteractionStation.json) | Optimisim         | v1.0.0  |
| VerifyIPFS         | [0xaE57e1B93DA10a7B5e746B2d17B0b3c7D90B2dDa](https://optimistic.etherscan.io/address/0xaE57e1B93DA10a7B5e746B2d17B0b3c7D90B2dDa)          | [abi](/abi/VerifyIPFS.json)         | Optimisim         | v1.0.0  |
| AlignIdRegistry    | [0x9CF4844B40e534c63A03C7F87E66A78F36fc92cA](https://sepolia-optimistic.etherscan.io/address/0x9CF4844B40e534c63A03C7F87E66A78F36fc92cA)  | [abi](/abi/AlignIdRegistry.json)    | Optimisim Sepolia | v1.0.0  |
| InteractionStation | [0x03158C08249e9DEEf562012BCA9001d9D686C692](https://sepolia-optimistic.etherscan.io/address/0x03158C08249e9DEEf562012BCA9001d9D686C692)  | [abi](/abi/InteractionStation.json) | Optimisim Sepolia | v1.0.0  |
| VerifyIPFS         | [0x20D0D19865b7b995667F7cB7c8ab5D0D774a10F4](https://sepolia-optimistic.etherscan.io/address/0x20D0D19865b7b995667F7cB7c8ab5D0D774a10F4)( | [abi](/abi/VerifyIPFS.json)         | Optimisim Sepolia | v1.0.0  |

### Create a new Interaction Type

When creating a new interaction type you must define the JSON file and upload it to the IPFS compatible Align Data
Network. Once uploaded use it in a script to register the type. Check `03_CreateInteractions.s.sol`

### Accompanying Typescript Repo

[typescript SDK Repo](https://github.com/alignnetwork/align-sdk)

### Deploy

`./bash/deploy.sh {IdRegistry|VerifyIPFS|InteractionStation|VerifyContracts|CreateInteractions|ChangeRoles} {mainnet|testnet}`

### Upload to Align Network

`./bash/upload.sh`

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
