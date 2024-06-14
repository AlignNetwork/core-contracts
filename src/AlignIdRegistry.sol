// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./auth/OwnableRoles.sol";

contract AlignIdRegistry is OwnableRoles {
  // ids
  mapping(address owner => uint256 alignId) public idOf;
  error IdExists();
  error NoId();
  error IncorrectId();
  error IncorrectAmount();
  error SourceHasNoId();
  error DestinationHasId();
  error NotOwner();
  error Paused();
  error NoTreasurySet();

  // Role constants
  uint256 public constant PAUSER_ROLE = 1 << 0;
  uint256 public constant WITHDRAWER_ROLE = 1 << 1;
  uint256 public constant FEE_SETTER_ROLE = 1 << 2;

  // Treasury
  address public treasury;

  bool public paused;

  uint256 public idCounter;
  uint256 public protocolFee;

  /// @notice Emitted when a new ID is registered
  /// @param to The address of the user being registered
  /// @param id The unique ID assigned to the user
  event AlignIdRegistered(address indexed to, uint256 indexed id);

  /// @notice Emitted when a new ID is transferred
  /// @param id The unique ID assigned to the user
  /// @param from The address of the user being transferred
  /// @param to The address of the user being transferred
  event Transfer(uint256 indexed id, address indexed from, address indexed to);

  /// @notice Emitted when the protocol fee is updated
  /// @param newFee The new protocol fee in wei
  event ProtocolFeeUpdated(uint256 newFee);

  /// @notice Emitted when the contract is paused or unpaused
  event PausedState(bool paused);

  /// @notice Emitted when funds are withdrawn
  /// @param amount The amount of funds withdrawn
  event Withdrawn(uint256 amount);

  /// @notice Emitted when the treasury address is updated
  /// @param newTreasury The new treasury address
  event TreasuryUpdated(address newTreasury);

  constructor(uint256 _initialFee, address _treasury) {
    _initializeOwner(msg.sender);
    protocolFee = _initialFee;
    treasury = _treasury;
  }

  /// @notice Registers a new ID for a user
  /// @return alignId The new unique ID assigned to the user
  /// @dev Emits a `Register` event upon successful registration
  function register() public payable returns (uint256 alignId) {
    if (paused) revert Paused();

    if (msg.value != protocolFee) {
      revert IncorrectAmount();
    }
    if (idOf[msg.sender] != 0) {
      revert IdExists();
    }

    alignId = ++idCounter;

    idOf[msg.sender] = alignId;

    emit AlignIdRegistered(msg.sender, alignId);
  }

  /// @notice Registers a new ID for a user on behalf of another address
  /// @param to The address to register the ID for
  /// @return alignId The new unique ID assigned to the user
  /// @dev Emits a `AlignIdRegistered` event upon successful registration
  function registerTo(address to) public payable returns (uint256 alignId) {
    if (paused) revert Paused();

    if (msg.value != protocolFee) {
      revert IncorrectAmount();
    }
    if (idOf[to] != 0) {
      revert IdExists();
    }

    alignId = ++idCounter;

    idOf[to] = alignId;

    emit AlignIdRegistered(to, alignId);
  }

  /// @notice Retrieves or assigns an ID for a given address
  /// @param to The address to retrieve or assign an ID for
  /// @return alignId The ID of the given address
  function readId(address to) public view returns (uint256 alignId) {
    // if no id, then revert
    alignId = idOf[to];
    if (alignId == 0) revert NoId();
  }

  function transfer(address from, address to) public {
    if (idOf[from] == 0) revert SourceHasNoId();

    if (idOf[to] != 0) revert DestinationHasId();

    if (msg.sender != from) revert NotOwner();

    uint256 idToTransfer = idOf[from];

    idOf[to] = idToTransfer;
    delete idOf[from];

    emit Transfer(idToTransfer, from, to);
  }

  /// @notice Allows the owner to update the protocol fee
  /// @param newFee The new protocol fee in wei
  function setProtocolFee(uint256 newFee) public onlyRolesOrOwner(FEE_SETTER_ROLE) {
    protocolFee = newFee;
    emit ProtocolFeeUpdated(newFee);
  }

  /// @notice Allows the owner to set the treasury address
  /// @param newTreasury The new treasury address
  function setTreasury(address newTreasury) public onlyOwner {
    if (newTreasury == address(0)) revert NoTreasurySet();
    treasury = newTreasury;
    emit TreasuryUpdated(newTreasury);
  }

  /// @notice Allows the owner to withdraw collected fees
  function withdraw() public onlyRolesOrOwner(WITHDRAWER_ROLE) {
    if (treasury == address(0)) {
      revert NoTreasurySet();
    }
    (bool success, ) = payable(treasury).call{ value: address(this).balance }("");
    require(success, "Withdraw failed");
  }

  /// @notice Allows the owner or pauser to pause or unpause the contract
  function setPaused(bool _paused) public onlyRolesOrOwner(PAUSER_ROLE) {
    paused = _paused;
    emit PausedState(paused);
  }
}
