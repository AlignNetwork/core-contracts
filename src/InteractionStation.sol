// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./AlignIdRegistry.sol";
import "./auth/Ownable.sol";
import "./VerifyIPFS.sol";

/// @title InteractionStation
/// @notice This contract allows for recording and managing offchain interactions.
/// @dev This contract utilizes mappings to store interactions and user information.
/// @dev iTypeKey references an InteractionType
/// @dev iKey references an Interaction
/// @dev iCID / iTypeCID references Interaction data or InteractionType data stored on IPFS using the CIDv1 format
contract InteractionStation is Ownable {
  error NoInteractionType();
  error InteractionTypeExists();
  error AlreadyInteracted();
  error NotInteractionCreator();
  error NoInteraction();
  error OnlyCreatorCanReference();

  struct Interaction {
    bytes32 key;
    string iCID;
    bytes32 parentIKey;
  }

  /// Interaction type
  struct IType {
    bytes32 key;
    uint256 issuerAlignId;
    string name;
    bool fungible;
    bool onlyCreator;
    bytes32[] parentKeys;
    string[] iTypeCID;
  }

  /// @notice Emitted when a new interaction is made
  /// @param iKey The key of the interaction
  /// @param iTypeKey The key of the interaction
  /// @param issuerAlignId The address of the issuer
  /// @param toAlignId The unique ID of the user for whom the interaction is made
  /// @param iCID The interaction
  /// @param fungibleKey The key if fungibleKey
  /// @param parentIKey The key of the referenced interaction
  event InteractionAdded(
    bytes32 indexed iKey,
    bytes32 indexed iTypeKey,
    uint256 issuerAlignId,
    uint256 toAlignId,
    string iCID,
    bytes32 fungibleKey,
    bytes32 parentIKey
  );

  /// @notice Emitted when a new interaction type CID is added to a interaction type
  /// @param iTypeKey The key of the interaction type
  /// @param iCID The new interaction CID
  event ITypeCIDAdded(bytes32 indexed iTypeKey, string iCID);

  /// @notice Emitted when a new type is stored
  /// @param iTypeKey The key of the interaction being stored
  /// @param issuerAlignId The address of the issuer
  /// @param name The name of interaction being stored
  /// @param iTypeCID The link to additional Information about the interaction
  /// @param fungible Whether the interaction is fungible
  /// @param parentKeys The keys of the referenced InteractionTypes
  event ITypeRegistered(
    bytes32 indexed iTypeKey,
    uint256 issuerAlignId,
    string name,
    string iTypeCID,
    bool fungible,
    bytes32[] parentKeys
  );

  /// @notice Mapping of Interactions
  mapping(bytes32 key => mapping(bytes32 => Interaction interaction)) private _interactions;
  /// @notice Mapping of InteractionTypes
  mapping(bytes32 interactionTypeKey => IType interactionType) private _iTypeRegistry;

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
  /// @param fungible Whether the claim is fungible
  /// @param onlyCreator Whether the claim is only creatable by the issuer
  /// @param name The reference name of the interaction
  /// @param iTypeCID The link to additional Information about the Claim
  /// @param parentKeys The keys of the referenced InteractionTypes
  /// @dev Emits a `interactionTypeRegistered` event upon successful storage
  function createIType(
    bool fungible,
    bool onlyCreator,
    string calldata name,
    string calldata iTypeCID,
    bytes32[] calldata parentKeys
  ) external returns (bytes32 key) {
    verifyIPFS.isCIDv1(iTypeCID);
    uint256 issuerAlignId = alignIdContract.readId(msg.sender);
    key = keccak256(abi.encodePacked(issuerAlignId, name));

    if (_iTypeRegistry[key].key != 0) revert InteractionTypeExists();

    _iTypeRegistry[key] = IType({
      key: key,
      issuerAlignId: issuerAlignId,
      name: name,
      fungible: fungible,
      onlyCreator: onlyCreator,
      parentKeys: new bytes32[](0),
      iTypeCID: new string[](0)
    });

    for (uint256 i = 0; i < parentKeys.length; i++) {
      if (_iTypeRegistry[parentKeys[i]].key == 0) revert NoInteractionType();
      if (_iTypeRegistry[parentKeys[i]].onlyCreator) revert OnlyCreatorCanReference();
      _iTypeRegistry[key].parentKeys.push(parentKeys[i]);
    }

    _iTypeRegistry[key].iTypeCID.push(iTypeCID);

    emit ITypeRegistered(key, issuerAlignId, name, iTypeCID, fungible, parentKeys);
  }

  /// @notice Create a new interaction
  /// @param toAlignId The id of the user for whom the interaction is being made
  /// @param iTypeKey The key of the interaction
  /// @param iCID The interaction data
  /// @param parentIKey The key of the referenced interaction
  /// @dev Emits an `Interacted` event upon successful interaction
  function interact(
    uint256 toAlignId,
    bytes32 iTypeKey,
    string calldata iCID,
    bytes32 parentIKey
  ) external returns (bytes32 iKey, bytes32 fungibleKey) {
    verifyIPFS.isCID(iCID);
    uint256 issuerAlignId = alignIdContract.readId(msg.sender);

    // check if interactionTypeKey exists in
    if (_iTypeRegistry[iTypeKey].key == 0) revert NoInteractionType();

    // check if issuer is allowed to interactITypeCIDAdded
    if (_iTypeRegistry[iTypeKey].onlyCreator && issuerAlignId != _iTypeRegistry[iTypeKey].issuerAlignId)
      revert NotInteractionCreator();

    // Create interaction key
    iKey = keccak256(abi.encodePacked(issuerAlignId, toAlignId, iTypeKey));
    fungibleKey = 0;

    if (_iTypeRegistry[iTypeKey].fungible) {
      fungibleKey = keccak256(abi.encodePacked(iCID));
      if (_interactions[iKey][fungibleKey].key != 0) revert AlreadyInteracted();
      _interactions[iKey][fungibleKey] = Interaction(iKey, iCID, parentIKey);
    } else {
      if (_interactions[iKey][fungibleKey].key != 0) revert AlreadyInteracted();
      _interactions[iKey][fungibleKey] = Interaction(iKey, iCID, parentIKey);
    }

    emit InteractionAdded(iKey, iTypeKey, issuerAlignId, toAlignId, iCID, fungibleKey, parentIKey);
  }

  function getICIDFungible(
    uint256 issuerAlignId,
    uint256 toAlignId,
    bytes32 iTypeKey,
    string calldata iCID
  ) external view returns (bool exists) {
    bytes32 iKey = keccak256(abi.encodePacked(issuerAlignId, toAlignId, iTypeKey));
    bytes32 fungibleKey = keccak256(abi.encodePacked(iCID));

    if (_interactions[iKey][fungibleKey].key == 0) exists = false;
    else exists = true;
  }

  function getICIDNonFungible(
    uint256 issuerAlignId,
    uint256 toAlignId,
    bytes32 iTypeKey
  ) external view returns (bool exists) {
    bytes32 key = keccak256(abi.encodePacked(issuerAlignId, toAlignId, iTypeKey));
    key = _interactions[key][0].key;
    if (_interactions[key][0].key == 0) exists = false;
    else exists = true;
  }

  function getITypeCID(bytes32 iTypeKey) external view returns (string memory iCID) {
    for (uint256 i = 0; i < _iTypeRegistry[iTypeKey].iTypeCID.length; i++) {
      iCID = _iTypeRegistry[iTypeKey].iTypeCID[i];
    }
  }

  /// @notice Retrieves the claim for a specific issuer and type
  /// @param issuerAlignId The address of the issuer
  /// @param name The  being retrieved
  /// @return iKey The key of the interaction
  /// @dev Reverts if no ID exists for the given address
  function getITypeKey(uint256 issuerAlignId, string calldata name) external pure returns (bytes32) {
    return keccak256(abi.encodePacked(issuerAlignId, name));
  }

  /// @notice Adds a new interaction link to a interaction type
  /// @param iTypeKey The key for the interaction type
  /// @param iTypeCID The new interaction cid to add
  /// @dev Emits an `interactionTypeLinkAdded` event upon successful addition of a new link
  function addITypeCID(bytes32 iTypeKey, string calldata iTypeCID) external {
    // Access control: Ensure only the issuer creator
    if (alignIdContract.readId(msg.sender) != _iTypeRegistry[iTypeKey].issuerAlignId) revert Unauthorized();

    // Ensure the Interaction type exists
    if (_iTypeRegistry[iTypeKey].key == 0) revert NoInteractionType();

    // Add the new cid to the array
    _iTypeRegistry[iTypeKey].iTypeCID.push(iTypeCID);

    emit ITypeCIDAdded(iTypeKey, iTypeCID);
  }

  function isITypeRegistered(bytes32 iTypeKey) external view returns (bool) {
    return _iTypeRegistry[iTypeKey].key != 0;
  }

  function updateAlignIdContract(address _alignIdContract) external onlyOwner {
    alignIdContract = AlignIdRegistry(_alignIdContract);
  }

  function updateOnlyCreator(bytes32 iTypeKey, bool _onlyCreator) public {
    if (alignIdContract.readId(msg.sender) != _iTypeRegistry[iTypeKey].issuerAlignId) revert Unauthorized();
    _iTypeRegistry[iTypeKey].onlyCreator = _onlyCreator;
  }
}
