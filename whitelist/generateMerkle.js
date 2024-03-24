const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");

// Replace this with the user's address you want to whitelist
const whitelistedAddresses = [
  "0x0000000000000000000000000000000000000002",
  "0x0000000000000000000000000000000000000003",
];

const leafNodes = whitelistedAddresses.map((addr) => keccak256(addr));
const merkleTree = new MerkleTree(leafNodes, keccak256, { sortPairs: true });
const root = merkleTree.getHexRoot();

// Generating a proof for the first (and only) address in the whitelist
const leaf = keccak256(whitelistedAddresses[0]);
const proof = merkleTree.getHexProof(leaf);

console.log("Merkle Root:", root);
console.log("Proof for Address:", proof);

// Output the root and proof to use in your tests
