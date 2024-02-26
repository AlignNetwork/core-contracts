// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import { IEAS } from "@ethereum-attestation-service/eas-contracts/contracts/IEAS.sol";
import { ISchemaRegistry } from "@ethereum-attestation-service/eas-contracts/contracts/ISchemaRegistry.sol";
import { AlignResolver } from "../src/AlignResolver.sol";

contract ValidatorRegistryV1 {
  address public admin;
  uint256 public constant STAKE_AMOUNT = 0.1 ether;
  IEAS eas = IEAS(0xd37555E77B61a0c13B0eEED15a61138Bb494A6F9);
  ISchemaRegistry schemaRegistry = ISchemaRegistry(0x3d02447b4431ed8bB6FDb035Ab4451f5F5A88063);

  struct Validator {
    address validator;
    string name;
    uint approvalRating;
    bool isRegistered;
    bool isActive;
    address resolver;
    string rules;
    uint256 stake;
    bytes32 schema;
  }

  mapping(address => Validator) public validators;
  address[] public validatorList;

  event ValidatorAdded(address indexed validator);
  event ValidatorRemoved(address indexed validator);
  event ValidatorSlashed(address indexed validator, uint256 slashedAmount);

  constructor() {
    admin = msg.sender;
  }

  // Modifier to restrict function access to only the admin
  modifier onlyAdmin() {
    require(msg.sender == admin, "Only admin can perform this action");
    _;
  }

  // Function to add a new validator
  function addValidator(address _validator, string memory _rules, string memory _name) public payable {
    require(msg.value == STAKE_AMOUNT, "Incorrect stake amount");
    require(!validators[_validator].isRegistered, "Validator already registered");
    AlignResolver resolver = new AlignResolver(IEAS(eas), msg.sender);
    // create an eas schema for the validator
    bytes32 schema = schemaRegistry.register("bool attended, string name, uint256 time", resolver, false);

    validators[_validator] = Validator(
      _validator,
      _name,
      100,
      true,
      true,
      address(resolver),
      _rules,
      msg.value,
      schema
    );

    validatorList.push(_validator);

    emit ValidatorAdded(_validator);
  }

  // Function to remove a validator
  function removeValidator(address _validator) public {
    require(validators[_validator].isRegistered, "Validator not registered");
    require(msg.sender == admin || msg.sender == _validator, "Only admin or validator can remove");

    uint256 stake = validators[_validator].stake;
    validators[_validator].isActive = false;

    emit ValidatorRemoved(_validator);

    payable(_validator).transfer(stake);
  }

  function slashValidator(address _validator) public onlyAdmin {
    require(validators[_validator].isRegistered, "Validator not registered");

    validators[_validator].approvalRating = 0; // Set approval rating to zero
    validators[_validator].isActive = false; // Set the validator to inactive

    uint256 stake = validators[_validator].stake;
    validators[_validator].stake = 0; // Reset the deposit

    emit ValidatorSlashed(_validator, stake);

    // Transfer the slashed deposit to the admin (eventaully DAO)
    payable(admin).transfer(stake);
  }

  function getValidatorStatus() public view returns (bool) {
    return validators[msg.sender].isActive;
  }

  // Function to get the approval rating of a validator
  function getApprovalRating(address _validator) public view returns (uint) {
    require(validators[_validator].isRegistered, "Validator not registered");
    return validators[_validator].approvalRating;
  }

  // function to get list of validators
  function getValidators() public view returns (address[] memory) {
    return validatorList;
  }

  function getAllValidators() public view returns (Validator[] memory) {
    Validator[] memory _validators = new Validator[](validatorList.length);
    for (uint256 i = 0; i < validatorList.length; i++) {
      _validators[i] = validators[validatorList[i]];
    }
    return _validators;
  }

  function readValidator(address _validator) public view returns (Validator memory) {
    return validators[_validator];
  }

  function updateResolverAddress(address _validator, address _resolver) public {
    require(validators[_validator].isRegistered, "Validator not registered");
    require(msg.sender == admin || msg.sender == _validator, "Only admin or validator can update");
    validators[_validator].resolver = _resolver;
  }

  function updateRules(address _validator, string memory _rules) public {
    require(validators[_validator].isRegistered, "Validator not registered");
    require(msg.sender == admin || msg.sender == _validator, "Only admin or validator can update");
    validators[_validator].rules = _rules;
  }

  function updateName(address _validator, string memory _name) public {
    require(validators[_validator].isRegistered, "Validator not registered");
    require(msg.sender == admin || msg.sender == _validator, "Only admin or validator can update");
    validators[_validator].name = _name;
  }
}
