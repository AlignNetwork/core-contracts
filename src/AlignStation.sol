// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./AlignId.sol";

/// @title AlignStation
/// @notice This contract allows for the attestation of claims by attesters for users.
/// @dev This contract utilizes mappings to store attestations and user information.
contract AlignStation {
  struct Attestation {
    uint256 attesterAlignId;
    bytes claim;
    bytes claimProof;
    // uint256 timestamp -
    // bool disputed?
    //
  }

  /// @notice Emitted when a new attestation is made
  /// @param asserter The address of the attester
  /// @param alignId The unique ID of the user for whom the attestation is made
  /// @param claimKey The key of the claim being attested to
  /// @param claim The claim data
  /// @param claimProof Proof of the claim
  event Attested(
    address indexed asserter,
    uint256 indexed alignId,
    bytes indexed claimKey,
    bytes claim,
    bytes claimProof
  );

  mapping(uint256 => mapping(bytes => Attestation)) public attestations;
  mapping(uint256 => bytes32[]) public attesterToClaimType;

  /// @notice Emitted when a new type is stored
  /// @param attester The address of the attester
  /// @param attestType The type of attestation being stored
  event ClaimTypeStored(address indexed attester, string indexed attestType);

  // id Contract
  AlignId public alignIdContract;

  /// @dev Initializes the contract with the AlignId contract
  constructor(address _alignIdContract) {
    alignIdContract = AlignId(_alignIdContract);
  }

  /// @notice Allows an attester to attest a claim for a user
  /// @param attester The address of the attester making the attestation
  /// @param to The address of the user for whom the attestation is being made
  /// @param claimKey The key of the claim being attested to
  /// @param claim The claim data
  /// @param claimProof Proof of the claim
  /// @dev Emits an `Attested` event upon successful attestation claimKey = keccak256(abi.encode(attesterAlignId, attestType));
  function attest(
    address attester,
    address to,
    bytes calldata claimKey,
    bytes calldata claim,
    bytes calldata claimProof
  ) external {
    // see if they have an Id
    uint256 alignId = alignIdContract.getId(to);
    // make an align id for the attester
    uint256 attesterAlignId = alignIdContract.getId(attester);

    // store the attestation by user, attester, and type
    //bytes32 typeKey = keccak256(abi.encode(attesterAlignId, attestType));
    attestations[alignId][claimKey] = Attestation(attesterAlignId, claim, claimProof);

    emit Attested(attester, alignId, claimKey, claim, claimProof);
  }

  /// @notice Retrieves the claim for a specific attester and type
  /// @param to The address of the user
  /// @param attester The address of the attester
  /// @param claimType The type of claim being retrieved
  /// @return claim The claim data
  /// @dev Reverts if no ID exists for the given address
  function getClaim(address to, address attester, bytes32 claimType) public view returns (bytes memory claim) {
    uint256 alignId = alignIdContract.getId(to);
    bytes memory claimKey = abi.encodePacked(keccak256(abi.encode(attester, claimType)));
    claim = attestations[alignId][claimKey].claim;
  }

  /// @notice Stores a new type of attestation for an attester
  /// @param attester The address of the attester
  /// @param claimType The type of attestation being stored
  /// @dev Emits a `TypeStored` event upon successful storage
  function storeType(address attester, string calldata claimType) external {
    uint256 attesterAlignId = alignIdContract.getId(attester);
    bytes32 typeKey = keccak256(abi.encode(attester, claimType));

    // Append typeKey to the attester's list if it's not already there
    bool exists = false;
    for (uint i = 0; i < attesterToClaimType[attesterAlignId].length; i++) {
      if (attesterToClaimType[attesterAlignId][i] == typeKey) {
        exists = true;
        break;
      }
    }
    if (!exists) {
      attesterToClaimType[attesterAlignId].push(typeKey);
    }

    emit ClaimTypeStored(attester, claimType);
  }

  function updateAlignIdContract(address _alignIdContract) external {
    alignIdContract = AlignId(_alignIdContract);
  }
}
