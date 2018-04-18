// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      from: '0xeaf8875787fa64d136919942cc7fbedc0ada7947', // optional,
      network_id: '*' // Match any network id
    }
  }
}
