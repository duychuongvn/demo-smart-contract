pragma solidity ^0.4.18;

import "./TokenERC20.sol";
import "./Owned.sol";

contract SmartdevCoin is owned, TokenERC20 {

    uint256 public sellPrice;
    uint256 public buyPrice;

    mapping(address => bool) public frozenAccount;

    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function SmartdevCoin(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}

    function getBuyPrice() public returns(uint256 buyPrice) {
        return buyPrice;
    }

    function getSellPrice() public returns(uint256 sellPrice) {
        return sellPrice;

    }
    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        // Prevent transfer to 0x0 address. Use burn() instead
        require(balanceOf[_from] >= _value);
        // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Check for overflows
        require(!frozenAccount[_from]);
        // Check if sender is frozen
        require(!frozenAccount[_to]);
        // Check if recipient is frozen
        balanceOf[_from] -= _value;
        // Subtract from the sender
        balanceOf[_to] += _value;
        // Add the same to the recipient
        emit Transfer(_from, _to, _value);
    }

    /// @notice Create `mintedAmount` tokens and send it to `target`
    /// @param target Address to receive the tokens
    /// @param mintedAmount the amount of tokens it will receive
    function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        emit Transfer(0, owner, mintedAmount);
        emit Transfer(owner, target, mintedAmount);
    }

    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
    /// @param target Address to be frozen
    /// @param freeze either to freeze it or not
    function freezeAccount(address target, bool freeze) onlyOwner public {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }

    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
    /// @param newSellPrice Price the users can sell to the contract
    /// @param newBuyPrice Price users can buy from the contract
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    /// @notice Buy tokens from contract by sending ether
    function buy() payable public {
        uint tokenAmount = msg.value / buyPrice;
        // calculates the amount
        _transfer(owner, msg.sender, tokenAmount);
        // makes the transfers
    }

    function buy(uint256 amount) payable external {
        uint256 tokenAmount = amount * 10 ** uint256(decimals) / buyPrice;
        _transfer(owner, msg.sender, tokenAmount);
    }
    /// @notice Sell `amount` tokens to contract
    function sell(uint256 amount) external {
        require(owner.balance >= amount * sellPrice);
        // checks if the contract has enough ether to buy
        _transfer(msg.sender, owner, amount);
        // makes the transfers
        msg.sender.transfer(amount * sellPrice);
        // sends ether to the seller. It's important to do this last to avoid recursion attacks
    }

}