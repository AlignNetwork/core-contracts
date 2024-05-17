// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./AlignIdRegistry.sol";
import "./auth/Ownable.sol";
import "./VerifyIPFS.sol";

/// @title InteractionStation
/// @notice This contract allows for the attestation of claims by attesters for users.
/// @dev This contract utilizes mappings to store attestations and user information.
contract InteractionStation is Ownable {
  error NoInteractionType();
  error InteractionTypeExists();
  error AlreadyInteracted();
  error NotInteractionCreator();
  error NoInteraction();
  error OnlyCreatorCanReference();

  struct Interaction {
    bytes32 key;
    string data;
    bytes32[] disputes;
  }

  /// Interaction type
  struct InteractionType {
    bytes32 key;
    uint256 issuerAlignId;
    string name;
    bool fungible;
    bool onlyCreator;
    bytes32[] referenceKeys;
    string[] links;
  }

  /// @notice Emitted when a new interaction is made
  /// @param interactionKey The key of the claim being attested to
  /// @param issuerAlignId The address of the issuer
  /// @param toAlignId The unique ID of the user for whom the interaction is made
  /// @param data The interaction data
  /// @param attestationKey2 The key of the attestation
  event Interacted(
    bytes32 indexed interactionKey,
    uint256 issuerAlignId,
    uint256 toAlignId,
    string data,
    bytes32 attestationKey2
  );

  /// @notice Emitted when a new interaction type link is added to a interaction type
  /// @param interactionTypeKey The key of the interaction type
  /// @param newLink The new interaction link
  event InteractionTypeLinkAdded(bytes32 indexed interactionTypeKey, string newLink);

  /// @notice Emitted when a new interaction is disputed
  /// @param interactionKey The key of the interaction
  /// @param interactionTypeKeyFungible The key of the client type
  /// @param disputeInteraction The disputed interaction
  event InteractionDisputed(
    bytes32 indexed interactionKey,
    bytes32 indexed interactionTypeKeyFungible,
    bytes32 disputeInteraction
  );

  mapping(bytes32 key => mapping(bytes32 => Interaction interaction)) private _interactions;
  mapping(bytes32 interactionTypeKey => InteractionType interactionType) private _interactionTypeRegistry;

  /// @notice Emitted when a new type is stored
  /// @param key The key of the claim being stored
  /// @param issuerAlignId The address of the attester
  /// @param interaction The type of attestation being stored
  /// @param link The link to additional Information about the Claim
  /// @param fungible Whether the claim is fungible
  event InteractionTypeRegistered(
    bytes32 indexed key,
    uint256 issuerAlignId,
    string interaction,
    string link,
    bool fungible,
    bytes32[] referenceKeys
  );

  // id Contract
  AlignIdRegistry public alignIdContract;
  VerifyIPFS public verifyIPFS;

  /// @dev Initializes the contract with the AlignId contract
  constructor(address _alignIdContract, address _verifyIPFS) {
    _initializeOwner(msg.sender);
    alignIdContract = AlignIdRegistry(_alignIdContract);
    verifyIPFS = VerifyIPFS(_verifyIPFS);
  }

  /// @notice Creates a new Interaction Type
  /// @param name The reference name of the interaction
  /// @param link The link to additional Information about the Claim
  /// @dev Emits a `interactionTypeRegistered` event upon successful storage
  function createInteractionType(
    bool fungible,
    bool onlyCreator,
    string calldata name,
    string calldata link,
    bytes32[] calldata referenceKeys
  ) external returns (bytes32 key) {
    verifyIPFS.isCIDv1(link);
    uint256 issuerAlignId = alignIdContract.readId(msg.sender);
    key = keccak256(abi.encodePacked(issuerAlignId, name));

    if (_interactionTypeRegistry[key].key != 0) revert InteractionTypeExists();

    _interactionTypeRegistry[key] = InteractionType({
      key: key,
      issuerAlignId: issuerAlignId,
      name: name,
      fungible: fungible,
      onlyCreator: onlyCreator,
      referenceKeys: new bytes32[](0),
      links: new string[](0)
    });

    for (uint256 i = 0; i < referenceKeys.length; i++) {
      if (_interactionTypeRegistry[referenceKeys[i]].key == 0) revert NoInteractionType();
      if (_interactionTypeRegistry[referenceKeys[i]].onlyCreator) revert OnlyCreatorCanReference();
      _interactionTypeRegistry[key].referenceKeys.push(referenceKeys[i]);
    }

    _interactionTypeRegistry[key].links.push(link);

    emit InteractionTypeRegistered(key, issuerAlignId, name, link, fungible, referenceKeys);
  }

  /// @notice Create a new interaction
  /// @param toAlignId The address of the user for whom the interaction is being made
  /// @param interactionTypeKey The key of the interaction
  /// @param interaction The interaction data
  /// @dev Emits an `Interacted` event upon successful interaction
  function interact(uint256 toAlignId, bytes32 interactionTypeKey, string calldata interaction) external {
    verifyIPFS.isCID(interaction);
    uint256 issuerAlignId = alignIdContract.readId(msg.sender);

    // check if interactionTypeKey exists in
    if (_interactionTypeRegistry[interactionTypeKey].key == 0) revert NoInteractionType();

    // check if issuer is allowed to interact
    if (
      _interactionTypeRegistry[interactionTypeKey].onlyCreator &&
      issuerAlignId != _interactionTypeRegistry[interactionTypeKey].issuerAlignId
    ) revert NotInteractionCreator();

    // Create interaction key
    bytes32 interactionKey = keccak256(abi.encodePacked(issuerAlignId, toAlignId, interactionTypeKey));
    bytes32 fungibleKey = 0;

    if (_interactionTypeRegistry[interactionTypeKey].fungible) {
      fungibleKey = keccak256(abi.encodePacked(interaction));
      if (_interactions[interactionKey][fungibleKey].key != 0) revert AlreadyInteracted();
      _interactions[interactionKey][fungibleKey] = Interaction(interactionKey, interaction, new bytes32[](0));
    } else {
      if (_interactions[interactionKey][fungibleKey].key != 0) revert AlreadyInteracted();
      _interactions[interactionKey][fungibleKey] = Interaction(interactionKey, interaction, new bytes32[](0));
    }

    emit Interacted(interactionTypeKey, issuerAlignId, toAlignId, interaction, fungibleKey);
  }

  function dispute(bytes32 disputedInteractionKey, bytes32 disputeInteraction) external {
    // check if interaction exists
    if (_interactions[disputedInteractionKey][0].key == 0) revert NoInteraction();

    // check if interaction is fungible
    bytes32 fungibleKey;
    if (_interactions[disputedInteractionKey][0].key == 0) fungibleKey = 0;
    else fungibleKey = keccak256(abi.encodePacked(disputedInteractionKey));
    _interactions[disputedInteractionKey][fungibleKey].disputes.push(disputeInteraction);

    emit InteractionDisputed(disputedInteractionKey, fungibleKey, disputeInteraction);
  }

  function getInteractionFungible(
    uint256 issuerAlignId,
    uint256 toAlignId,
    bytes32 interactionTypeKey,
    string calldata interactionData
  ) external view returns (string memory interaction) {
    bytes32 interactionKey = keccak256(abi.encodePacked(issuerAlignId, toAlignId, interactionTypeKey));
    bytes32 fungibleKey = keccak256(abi.encodePacked(interactionData)); // Now correctly using interaction data for the fungible key

    if (_interactions[interactionKey][fungibleKey].key == 0) revert NoInteraction();

    interaction = _interactions[interactionKey][fungibleKey].data;
    return interaction;
  }

  function getInteractionNonFungible(
    uint256 issuerAlignId,
    uint256 toAlignId,
    bytes32 interactionKey
  ) external view returns (string memory interaction) {
    bytes32 attestationKey = keccak256(abi.encodePacked(issuerAlignId, toAlignId, interactionKey));
    attestationKey = _interactions[attestationKey][0].key;
    interaction = _interactions[attestationKey][0].data;
  }

  /// @notice Retrieves the claim for a specific issuer and type
  /// @param issuerAlignId The address of the issuer
  /// @param name The  being retrieved
  /// @return interactionKey The key of the interaction
  /// @dev Reverts if no ID exists for the given address
  function getInteractionTypeKey(uint256 issuerAlignId, string calldata name) external pure returns (bytes32) {
    return keccak256(abi.encodePacked(issuerAlignId, name));
  }

  /// @notice Adds a new interaction link to a interaction type
  /// @param interactionTypeKey The key for the interaction type
  /// @param newLink The new interaction link to add
  /// @dev Emits an `interactionTypeLinkAdded` event upon successful addition of a new link
  function addLink(bytes32 interactionTypeKey, string calldata newLink) external {
    // Access control: Ensure only the issuer creator
    require(
      alignIdContract.readId(msg.sender) == _interactionTypeRegistry[interactionTypeKey].issuerAlignId,
      "Unauthorized"
    );

    // Ensure the Interaction type exists
    require(_interactionTypeRegistry[interactionTypeKey].key != 0, "Interaction type does not exist");

    // Add the new link to the array
    _interactionTypeRegistry[interactionTypeKey].links.push(newLink);

    emit InteractionTypeLinkAdded(interactionTypeKey, newLink);
  }

  function isinteractionTypeRegistered(bytes32 interactionKey) external view returns (bool) {
    return _interactionTypeRegistry[interactionKey].key != 0;
  }

  function updateAlignIdContract(address _alignIdContract) external onlyOwner {
    alignIdContract = AlignIdRegistry(_alignIdContract);
  }
}
