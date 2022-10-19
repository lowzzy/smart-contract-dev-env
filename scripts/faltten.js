const { merge } = require('sol-merger');

// Get the merged code as a string
async function a() {
  const mergedCode = await merge('../contracts/Gfc.sol');
  console.log(mergedCode);
}
a();
// Print it out or write it to a file etc.
