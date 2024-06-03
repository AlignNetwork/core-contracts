Warning! "--ir-minimum" flag enables viaIR with minimum optimization, which can result in inaccurate source mappings.
Only use this flag as a workaround if you are experiencing "stack too deep" errors.
Note that "viaIR" is only available in Solidity 0.8.13 and above.
See more: https://github.com/foundry-rs/foundry/issues/3357
Compiling 33 files with 0.8.19
Solc 0.8.19 finished in 7.60s
Compiler run successful!
Analysing contracts...
Running tests...

Ran 2 tests for test/VerifyIPFS.t.sol:VerifyIPFSTest
[PASS] testVerifyIPFS() (gas: 84115)
[PASS] testVerifyIPFSFail() (gas: 12389)
Suite result: ok. 2 passed; 0 failed; 0 skipped; finished in 1.93ms (1.81ms CPU time)

Ran 26 tests for test/AlignIdRegistry.t.sol:AlignIdTest
[PASS] testReadId() (gas: 72577)
[PASS] testReadIdOf() (gas: 72737)
[PASS] testReadIdOfNotRegistered() (gas: 12589)
[PASS] testRegister() (gas: 72374)
[PASS] testRegisterEmitsIdRegistered() (gas: 72762)
[PASS] testRegisterPaused() (gas: 85639)
[PASS] testRegisterShouldFailIdExists() (gas: 74750)
[PASS] testRegisterShouldFailWithIncorrectAmount() (gas: 26554)
[PASS] testRegisterTo() (gas: 72459)
[PASS] testRegisterToEmitsIdRegistered() (gas: 73566)
[PASS] testRegisterToPaused() (gas: 86775)
[PASS] testRegisterToShouldFailIdExists() (gas: 76183)
[PASS] testRegisterToShouldFailWithIncorrectAmount() (gas: 26814)
[PASS] testSetPause() (gas: 127386)
[PASS] testSetProtocolFee() (gas: 41966)
[PASS] testSetTreasury() (gas: 26327)
[PASS] testSetTreasuryShouldFailWhenSetToZeroAddress() (gas: 78676)
[PASS] testTransfer() (gas: 94793)
[PASS] testTransferShouldEmitTransferEvent() (gas: 89504)
[PASS] testTransferShouldFailWhenDestinationHasId() (gas: 107403)
[PASS] testTransferShouldFailWhenSourceHasNoId() (gas: 19749)
[PASS] testTransferShouldFailWhenSourceIsNotOwner() (gas: 79914)
[PASS] testWithdrawByOwner() (gas: 84744)
[PASS] testWithdrawByWithdrawer() (gas: 116250)
[PASS] testWithdrawShouldFailWhenNoTreasury() (gas: 1587234)
[PASS] testWithdrawShouldFailWhenNotOwnerOrWithdrawer() (gas: 79583)
Suite result: ok. 26 passed; 0 failed; 0 skipped; finished in 9.95ms (12.92ms CPU time)

Ran 5 tests for test/InteractionStation.t.sol:AlignStationTest
[PASS] testAddITypeCID() (gas: 409024)
[PASS] testAlreadyInteractedFungibleRevert() (gas: 606107)
[PASS] testCreateInteractionType() (gas: 593093)
[PASS] testGetRegisterFungible() (gas: 524249)
[PASS] testRegisterFungible() (gas: 814173)
Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 9.96ms (24.15ms CPU time)

Ran 3 test suites in 21.13ms (21.83ms CPU time): 33 tests passed, 0 failed, 0 skipped (33 total tests)
| File                               | % Lines         | % Statements     | % Branches     | % Funcs        |
|------------------------------------|-----------------|------------------|----------------|----------------|
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
