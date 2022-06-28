// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require('hardhat');

async function main() {
  // Hardhatは、コマンドラインインターフェイスでスクリプトを実行する際に、常にコンパイルタスクを実行します。
  //
  // このスクリプトを `node` を使って直接実行する場合は、手動で compile を手動で呼び出して、すべてがコンパイルされていることを確認します。
  await hre.run('compile');

  // We get the contract to deploy
  const Greeter = await hre.ethers.getContractFactory('Greeter');
  const greeter = await Greeter.deploy('Hello, Hardhat!');

  await greeter.deployed();

  console.log('Greeter deployed to:', greeter.address);
}

// どこでもasync/awaitが使えて、エラーもきちんと処理できるように、このパターンを推奨します。
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
