const Web3 = require('web3')

const abis = {
  kleros: require('../graft-subgraph/abis/kleros-liquid.json'),
  poh: require('../graft-subgraph/abis/proof-of-humanity.json'),
  trxBatcher: require('../graft-subgraph/abis/transaction-batcher.json'),
  ubi: require('../graft-subgraph/abis/ubi.json'),
}

// Usage:
//
// node web3-playground/index.js https://eth-mainnet.alchemyapi.io/v2/YOUR_KEY
const provider = process.argv[2]

const web3 = new Web3(provider)

const Poh = new web3.eth.Contract(abis.poh, '0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb')
const Kleros = new web3.eth.Contract(abis.kleros, '0x988b3A538b618C7A603e1c11Ab82Cd16dbE28069')

async function main() {
  const submissionDuration = await Poh.methods.submissionDuration().call(
    // options
    null,
    // defaultBlock
    '14185505',// last change in entity
    // '12011577',// at contract creation
  )

  console.log(submissionDuration)
}

main()
  .catch(console.error)
