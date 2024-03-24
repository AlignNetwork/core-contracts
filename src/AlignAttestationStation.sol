// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./AlignIdRegistry.sol";
import "./auth/Ownable.sol";

/// @title AlignStation
/// @notice This contract allows for the attestation of claims by attesters for users.
/// @dev This contract utilizes mappings to store attestations and user information.
contract AlignAttestationStation is Ownable {
  error NotAdmin();
  error NoClaimType();
  error ClaimTypeExists();

  struct Attestation {
    bytes32 attesterKey;
    bytes32 claim;
    bytes32 claimProof;
  }

  struct ClaimTypeRecord {
    bytes32 claimTypeKey;
    uint256 attesterAlignId;
    string claimType;
    string claimLink;
  }

  /// @notice Emitted when a new attestation is made
  /// @param attesterAlignId The address of the attester
  /// @param toAlignId The unique ID of the user for whom the attestation is made
  /// @param claimTypeKey The key of the claim being attested to
  /// @param claim The claim data
  /// @param claimProof Proof of the claim
  event Attested(
    uint256 indexed attesterAlignId,
    uint256 indexed toAlignId,
    bytes32 indexed claimTypeKey,
    bytes32 claim,
    bytes32 claimProof
  );

  mapping(bytes32 attestationKey => Attestation attestation) private _attestations;
  mapping(bytes32 claimTypeKey => ClaimTypeRecord claimTypeRecord) private _claimTypeRegistry;

  /// @notice Emitted when a new type is stored
  /// @param attesterAlignId The address of the attester
  /// @param attestType The type of attestation being stored
  /// @param claimLink The link to additional Information about the Claim
  event ClaimTypeRegistered(uint256 indexed attesterAlignId, string indexed attestType, string claimLink);

  // id Contract
  AlignIdRegistry public alignIdContract;

  /// @dev Initializes the contract with the AlignId contract
  constructor(address _alignIdContract) {
    _initializeOwner(msg.sender);
    alignIdContract = AlignIdRegistry(_alignIdContract);
  }

  /// @notice Allows an attester to attest a claim for a user
  /// @param attesterAlignId The address of the attester making the attestation
  /// @param toAlignId The address of the user for whom the attestation is being made
  /// @param claimTypeKey The key of the claim being attested to
  /// @param claim The claim data
  /// @param claimProof Proof of the claim
  /// @dev Emits an `Attested` event upon successful attestation claimTypeKey = keccak256(abi.encode(attesterAlignId, attestType));
  function attest(
    uint256 attesterAlignId,
    uint256 toAlignId,
    bytes32 claimTypeKey,
    bytes32 claim,
    bytes32 claimProof
  ) external onlyOwner {
    // Create AttestionKey
    bytes32 attestationKey = keccak256(abi.encodePacked(attesterAlignId, toAlignId, claimTypeKey));
    // check if claimTypeKey exists in attesterToClaimType
    if (_claimTypeRegistry[claimTypeKey].claimTypeKey == 0) revert NoClaimType();

    // store the attestation by user, attester, and type
    _attestations[attestationKey] = Attestation(attestationKey, claim, claimProof);

    emit Attested(attesterAlignId, toAlignId, claimTypeKey, claim, claimProof);
  }

  function getAttestation(
    uint256 attesterAlignId,
    uint256 toAlignId,
    bytes32 claimTypeKey
  ) external view returns (bytes32 attesterKey, bytes32 claim, bytes32 claimProof) {
    bytes32 attestationKey = keccak256(abi.encodePacked(attesterAlignId, toAlignId, claimTypeKey));
    attesterKey = _attestations[attestationKey].attesterKey;
    claim = _attestations[attestationKey].claim;
    claimProof = _attestations[attestationKey].claimProof;
  }

  /*   /// @notice Retrieves the claim for a specific attester and type
  /// @param toAlignId The address of the user
  /// @param attesterAlignId The address of the attester
  /// @param claimType The type of claim being retrieved
  /// @return claim The claim data
  /// @dev Reverts if no ID exists for the given address */
  function getClaimTypeKey(uint256 attesterAlignId, string calldata claimType) external pure returns (bytes32) {
    return keccak256(abi.encodePacked(attesterAlignId, claimType));
  }

  /// @notice Stores a new type of attestation for an attester
  /// @param attesterAlignId The address of the attester
  /// @param claimType The type of attestation being stored
  /// @param claimLink The link to additional Information about the Claim
  /// @dev Emits a `ClaimTypeStored` event upon successful storage
  function registerType(
    uint256 attesterAlignId,
    string calldata claimType,
    string calldata claimLink
  ) external onlyOwner {
    bytes32 claimTypeKey = keccak256(abi.encodePacked(attesterAlignId, claimType));

    if (_claimTypeRegistry[claimTypeKey].claimTypeKey != 0) revert ClaimTypeExists();

    _claimTypeRegistry[claimTypeKey] = ClaimTypeRecord(claimTypeKey, attesterAlignId, claimType, claimLink);

    emit ClaimTypeRegistered(attesterAlignId, claimType, claimLink);
  }

  function isClaimTypeRegistered(bytes32 claimTypeKey) external view returns (bool) {
    return _claimTypeRegistry[claimTypeKey].claimTypeKey != 0;
  }

  function updateAlignIdContract(address _alignIdContract) external onlyOwner {
    alignIdContract = AlignIdRegistry(_alignIdContract);
  }
}
