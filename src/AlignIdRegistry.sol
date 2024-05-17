// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./auth/Ownable.sol";

contract AlignIdRegistry is Ownable {
  // ids
  mapping(address owner => uint256 alignId) public idOf;
  error IdExists();
  error NoId();
  error NotId();
  error IncorrectId();

  uint256 public idCounter;
  uint256 public devCounter = 10_001;

  /// @notice Emitted when a new ID is registered
  /// @param to The address of the user being registered
  /// @param id The unique ID assigned to the user
  event Register(address indexed to, uint256 indexed id);

  constructor() {
    _initializeOwner(msg.sender);
  }

  /// @notice Registers a new ID for a user
  /// @param to The address of the user being registered
  /// @return alignId The new unique ID assigned to the user
  /// @dev Emits a `Register` event upon successful registration
  function register(address to) public onlyOwner returns (uint256 alignId) {
    if (idOf[to] != 0) {
      revert IdExists();
    }

    // first user would be id 1
    alignId = ++idCounter;

    idOf[to] = alignId;

    emit Register(to, alignId);
  }

  /// @notice Registers a new ID for a developer
  /// @param to The address of the user being registered
  /// @return alignId The new unique ID assigned to the user
  /// @dev Emits a `Register` event upon successful registration
  function registerDev(address to) public onlyOwner returns (uint256 alignId) {
    if (idOf[to] != 0) {
      revert IdExists();
    }

    // first user would be id 1
    alignId = ++devCounter;

    idOf[to] = alignId;

    emit Register(to, alignId);
  }

  /// @notice Retrieves or assigns an ID for a given address
  /// @param to The address to retrieve or assign an ID for
  /// @return alignId The ID of the given address
  function readId(address to) public view returns (uint256 alignId) {
    // if no id, then revert
    alignId = idOf[to];
    if (alignId == 0) revert NoId();
  }

  function transferId(address from, address to) public onlyOwner {
    idOf[to] = idOf[from];
    idOf[from] = 0;
  }
}
