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
  error AlreadyAttested();
  error NotAttester();

  struct Attestation {
    bytes32 attestationKey;
    string claim;
    string claimProof;
  }

  struct ClaimTypeRecord {
    bytes32 claimTypeKey;
    uint256 attesterAlignId;
    string claimType;
    string claimLink;
    bool fungible;
    bool onlyAttesterCanAttest;
  }

  /// @notice Emitted when a new attestation is made
  /// @param claimTypeKey The key of the claim being attested to
  /// @param attesterAlignId The address of the attester
  /// @param toAlignId The unique ID of the user for whom the attestation is made
  /// @param claim The claim data
  /// @param claimProof Proof of the claim
  /// @param attestationKey2 The key of the attestation
  event Attested(
    bytes32 indexed claimTypeKey,
    uint256 attesterAlignId,
    uint256 toAlignId,
    string claim,
    string claimProof,
    bytes32 attestationKey2
  );

  mapping(bytes32 attestationKey => mapping(bytes32 => Attestation attestation)) private _attestations;
  mapping(bytes32 claimTypeKey => ClaimTypeRecord claimTypeRecord) private _claimTypeRegistry;

  /// @notice Emitted when a new type is stored
  /// @param claimTypeKey The key of the claim being stored
  /// @param attesterAlignId The address of the attester
  /// @param claimType The type of attestation being stored
  /// @param claimLink The link to additional Information about the Claim
  /// @param fungible Whether the claim is fungible
  event ClaimTypeRegistered(
    bytes32 indexed claimTypeKey,
    uint256 attesterAlignId,
    string claimType,
    string claimLink,
    bool fungible
  );

  // id Contract
  AlignIdRegistry public alignIdContract;

  /// @dev Initializes the contract with the AlignId contract
  constructor(address _alignIdContract) {
    _initializeOwner(msg.sender);
    alignIdContract = AlignIdRegistry(_alignIdContract);
  }

  /// @notice Allows an attester to attest a claim for a user
  /// @param toAlignId The address of the user for whom the attestation is being made
  /// @param claimTypeKey The key of the claim being attested to
  /// @param claim The claim data
  /// @param claimProof Proof of the claim
  /// @dev Emits an `Attested` event upon successful attestation claimTypeKey = keccak256(abi.encode(attesterAlignId, attestType));
  function attest(uint256 toAlignId, bytes32 claimTypeKey, string calldata claim, string calldata claimProof) external {
    uint256 attesterAlignId = alignIdContract.readId(msg.sender);

    // check if claimTypeKey exists in attesterToClaimType
    if (_claimTypeRegistry[claimTypeKey].claimTypeKey == 0) revert NoClaimType();

    // check if attester is allowed to attest
    if (
      _claimTypeRegistry[claimTypeKey].onlyAttesterCanAttest &&
      attesterAlignId != _claimTypeRegistry[claimTypeKey].attesterAlignId
    ) revert NotAttester();

    // Create AttestionKey
    bytes32 attestationKey = keccak256(abi.encodePacked(attesterAlignId, toAlignId, claimTypeKey));
    bytes32 attestationKey2 = 0;

    if (_claimTypeRegistry[claimTypeKey].fungible == false) {
      if (_attestations[attestationKey][attestationKey2].attestationKey != 0) revert AlreadyAttested();
      _attestations[attestationKey][attestationKey2] = Attestation(attestationKey, claim, claimProof);
    } else {
      attestationKey2 = keccak256(abi.encodePacked(claim));
      if (_attestations[attestationKey][attestationKey2].attestationKey != 0) revert AlreadyAttested();
      _attestations[attestationKey][attestationKey2] = Attestation(attestationKey, claim, claimProof);
    }

    emit Attested(claimTypeKey, attesterAlignId, toAlignId, claim, claimProof, attestationKey2);
  }

  function getAttestationFungible(
    uint256 attesterAlignId,
    uint256 toAlignId,
    bytes32 claimTypeKey,
    string calldata claimIn
  ) external view returns (string memory claimOut, string memory claimProof) {
    bytes32 attestationKey = keccak256(abi.encodePacked(attesterAlignId, toAlignId, claimTypeKey));
    bytes32 attestationKey2 = keccak256(abi.encodePacked(claimIn));
    attestationKey = _attestations[attestationKey][attestationKey2].attestationKey;
    claimOut = _attestations[attestationKey][attestationKey2].claim;
    claimProof = _attestations[attestationKey][attestationKey2].claimProof;
  }

  function getAttestationNonFungible(
    uint256 attesterAlignId,
    uint256 toAlignId,
    bytes32 claimTypeKey
  ) external view returns (string memory claimOut, string memory claimProof) {
    bytes32 attestationKey = keccak256(abi.encodePacked(attesterAlignId, toAlignId, claimTypeKey));
    attestationKey = _attestations[attestationKey][0].attestationKey;
    claimOut = _attestations[attestationKey][0].claim;
    claimProof = _attestations[attestationKey][0].claimProof;
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
  /// @param claimType The type of attestation being stored
  /// @param claimLink The link to additional Information about the Claim
  /// @dev Emits a `ClaimTypeStored` event upon successful storage
  function registerType(
    bool fungible,
    string calldata claimType,
    string calldata claimLink,
    bool onlyAttesterCanAttest
  ) external {
    uint256 attesterAlignId = alignIdContract.readId(msg.sender);
    bytes32 claimTypeKey = keccak256(abi.encodePacked(attesterAlignId, claimType));

    if (_claimTypeRegistry[claimTypeKey].claimTypeKey != 0) revert ClaimTypeExists();

    _claimTypeRegistry[claimTypeKey] = ClaimTypeRecord(
      claimTypeKey,
      attesterAlignId,
      claimType,
      claimLink,
      fungible,
      onlyAttesterCanAttest
    );

    emit ClaimTypeRegistered(claimTypeKey, attesterAlignId, claimType, claimLink, fungible);
  }

  function isClaimTypeRegistered(bytes32 claimTypeKey) external view returns (bool) {
    return _claimTypeRegistry[claimTypeKey].claimTypeKey != 0;
  }

  function updateAlignIdContract(address _alignIdContract) external onlyOwner {
    alignIdContract = AlignIdRegistry(_alignIdContract);
  }
}
