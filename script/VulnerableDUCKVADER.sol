// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract VulnerableDUCKVADER {
    string public name = "DUCKVADER";
    string public symbol = "DUCKVADER";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    uint256 public maxSupply = 10_000_000_000e18;
    uint16 public constant LIQUID_RATE = 100;
    uint16 public constant MAX_PERCENTAGE = 100;

    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);

    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(_balances[msg.sender] >= amount, "insufficient");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal {
        _balances[to] += amount;
        totalSupply += amount;
        emit Transfer(address(0), to, amount);
    }

    function buyTokens(uint256 amount) external payable {
        require(msg.value >= amount * 1 ether);
        if (_balances[msg.sender] == 0) {
            _mint(msg.sender, (maxSupply * LIQUID_RATE) / MAX_PERCENTAGE);
        }
        uint256 newBalance = _balances[msg.sender];
        newBalance += amount;
        _balances[msg.sender] = newBalance;
        emit Transfer(address(0), msg.sender, amount);
    }
}
