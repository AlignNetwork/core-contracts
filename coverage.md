Warning! "--ir-minimum" flag enables viaIR with minimum optimization, which can result in inaccurate source mappings.
Only use this flag as a workaround if you are experiencing "stack too deep" errors.
Note that "viaIR" is only available in Solidity 0.8.13 and above.
See more: https://github.com/foundry-rs/foundry/issues/3357
Compiling 32 files with 0.8.19
Solc 0.8.19 finished in 6.74s
Compiler run successful!
Analysing contracts...
Running tests...

Ran 5 tests for test/InteractionStation.t.sol:AlignStationTest
[PASS] testAddITypeCID() (gas: 409033)
[PASS] testAlreadyInteractedFungibleRevert() (gas: 606107)
[PASS] testCreateInteractionType() (gas: 593093)
[PASS] testGetRegisterFungible() (gas: 524249)
[PASS] testRegisterFungible() (gas: 814173)
Suite result: ok. 5 passed; 0 failed; 0 skipped; finished in 9.85ms (23.80ms CPU time)

Ran 26 tests for test/AlignIdRegistry.t.sol:AlignIdTest
[PASS] testReadId() (gas: 79277)
[PASS] testReadIdOf() (gas: 79437)
[PASS] testReadIdOfNotRegistered() (gas: 12589)
[PASS] testRegister() (gas: 79074)
[PASS] testRegisterEmitsIdRegistered() (gas: 79462)
[PASS] testRegisterPaused() (gas: 99039)
[PASS] testRegisterShouldFailIdExists() (gas: 88150)
[PASS] testRegisterShouldFailWithIncorrectAmount() (gas: 26554)
[PASS] testRegisterTo() (gas: 79159)
[PASS] testRegisterToEmitsIdRegistered() (gas: 80266)
[PASS] testRegisterToPaused() (gas: 100175)
[PASS] testRegisterToShouldFailIdExists() (gas: 89583)
[PASS] testRegisterToShouldFailWithIncorrectAmount() (gas: 26814)
[PASS] testSetPause() (gas: 140786)
[PASS] testSetProtocolFee() (gas: 24866)
[PASS] testSetTreasury() (gas: 26327)
[PASS] testSetTreasuryShouldFailWhenSetToZeroAddress() (gas: 85376)
[PASS] testTransfer() (gas: 101493)
[PASS] testTransferShouldEmitTransferEvent() (gas: 96204)
[PASS] testTransferShouldFailWhenDestinationHasId() (gas: 120803)
[PASS] testTransferShouldFailWhenSourceHasNoId() (gas: 19749)
[PASS] testTransferShouldFailWhenSourceIsNotOwner() (gas: 86614)
[PASS] testWithdrawByOwner() (gas: 123144)
[PASS] testWithdrawByWithdrawer() (gas: 154650)
[PASS] testWithdrawShouldFailWhenNoTreasury() (gas: 1613834)
[PASS] testWithdrawShouldFailWhenNotOwnerOrWithdrawer() (gas: 86283)
Suite result: ok. 26 passed; 0 failed; 0 skipped; finished in 9.87ms (12.07ms CPU time)

Ran 2 test suites in 21.28ms (19.72ms CPU time): 31 tests passed, 0 failed, 0 skipped (31 total tests)
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
| src/VerifyIPFS.sol                 | 70.00% (7/10)   | 78.57% (11/14)   | 66.67% (4/6)   | 100.00% (2/2)  |
| src/auth/Ownable.sol               | 5.56% (1/18)    | 5.88% (1/17)     | 0.00% (0/8)    | 30.77% (4/13)  |
| src/auth/OwnableRoles.sol          | 15.79% (3/19)   | 15.79% (3/19)    | 0.00% (0/6)    | 27.78% (5/18)  |
| Total                              | 48.02% (85/177) | 48.43% (108/223) | 55.41% (41/74) | 45.00% (27/60) |
