import Web3 from 'web3';

const ERC20TransferABI = [
  //   {
  //     constant: false,
  //     inputs: [
  //       {
  //         name: '_to',
  //         type: 'address',
  //       },
  //       {
  //         name: '_value',
  //         type: 'uint256',
  //       },
  //     ],
  //     name: 'transfer',
  //     outputs: [
  //       {
  //         name: '',
  //         type: 'bool',
  //       },
  //     ],
  //     payable: false,
  //     stateMutability: 'nonpayable',
  //     type: 'function',
  //   },
  //   {
  //     constant: true,
  //     inputs: [
  //       {
  //         name: '_owner',
  //         type: 'address',
  //       },
  //     ],
  //     name: 'balanceOf',
  //     outputs: [
  //       {
  //         name: 'balance',
  //         type: 'uint256',
  //       },
  //     ],
  //     payable: false,
  //     stateMutability: 'view',
  //     type: 'function',
  //   },
];

const abi = [
  {
    inputs: [
      {
        internalType: 'string',
        name: '_greeting',
        type: 'string',
      },
    ],
    stateMutability: 'nonpayable',
    type: 'constructor',
  },
  {
    inputs: [],
    name: 'greet',
    outputs: [
      {
        internalType: 'string',
        name: '',
        type: 'string',
      },
    ],
    stateMutability: 'view',
    type: 'function',
  },
  {
    inputs: [
      {
        internalType: 'string',
        name: '_greeting',
        type: 'string',
      },
    ],
    name: 'setGreeting',
    outputs: [],
    stateMutability: 'nonpayable',
    type: 'function',
  },
];

const DAI_ADDRESS = '0x5fbdb2315678afecb367f032d93f642f64180aa3';

const web3 = new Web3('http://127.0.0.1:8545/');

// const daiToken = new web3.eth.Contract(ERC20TransferABI, DAI_ADDRESS);
const daiToken = new web3.eth.Contract(abi, DAI_ADDRESS);

console.log('daiToken.methods');
console.log(daiToken.methods);
console.log('################');
daiToken.methods.greet().call(function (err, res) {
  if (err) {
    console.log('An error occured', err);
    return;
  }
  console.log('The balance is: ', res);
});
