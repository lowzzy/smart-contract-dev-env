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
  // getContractFactoryはコントラクトのファイル名
  const Gfc = await hre.ethers.getContractFactory('Gfc');
  // const ofuda = await Ofuda.deploy('lowzzy : Hello, Hardhat!');
  const gfc = await Gfc.deploy();

  await gfc.deployed();

  console.log('Gfc deployed to:', gfc.address);
}

// どこでもasync/awaitが使えて、エラーもきちんと処理できるように、このパターンを推奨します。
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
