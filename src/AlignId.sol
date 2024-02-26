// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract AlignId {
  address public admin;

  // ids
  mapping(address owner => uint256 alignId) public idOf;
  error IdExists();
  error NoId();
  uint256 public idCounter;

  /// @notice Emitted when a new ID is registered
  /// @param to The address of the user being registered
  /// @param id The unique ID assigned to the user
  /// @param recovery The recovery address associated with the user
  event Register(address indexed to, uint256 indexed id, address recovery);
  mapping(uint256 alignId => address custody) public custodyOf;
  mapping(uint256 alignId => address recovery) public recoveryOf;

  constructor(address _admin) {
    admin = _admin;
  }

  /// @notice Registers a new ID for a user
  /// @param to The address of the user being registered
  /// @param recovery The recovery address associated with the new ID
  /// @return alignId The new unique ID assigned to the user
  /// @dev Emits a `Register` event upon successful registration
  function register(address to, address recovery) public returns (uint256 alignId) {
    // if no id, check if from admin
    if (msg.sender != admin) revert("only admin can register");
    if (idOf[to] != 0) {
      revert IdExists();
    }
    /* Safety: idCounter won't realistically overflow. */
    unchecked {
      /* Incrementing before assignment ensures that no one gets the 0 alignId. */
      alignId = ++idCounter;
    }

    _unsafeRegister(alignId, to, recovery);
  }

  /// @dev Registers the alignId without checking invariants for internal use
  /// @param id The unique ID to be registered
  /// @param to The address of the user
  /// @param recovery The recovery address associated with the ID
  function _unsafeRegister(uint256 id, address to, address recovery) internal {
    idOf[to] = id;
    custodyOf[id] = to;
    recoveryOf[id] = recovery;

    emit Register(to, id, recovery);
  }

  /// @notice Retrieves or assigns an ID for a given address
  /// @param to The address to retrieve or assign an ID for
  /// @return alignId The ID of the given address
  function getId(address to) public view returns (uint256 alignId) {
    // if no id, then register
    alignId = idOf[to];
    if (alignId == 0) revert NoId();
  }
}
