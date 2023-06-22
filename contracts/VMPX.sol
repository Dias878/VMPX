// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract VMPX is ERC20("VMPX", "VMPX"), ERC20Capped(108_624_000_000 ether) {
    string public constant AUTHORS = "@MrJackLevin @ackebom @lbelyaev faircrypto.org";

    uint256 public constant BATCH = 200 ether;
    uint256 public immutable cycles; 

    mapping(address => uint256[]) private _work;

    constructor(uint256 cycles_) {
        require(cycles_ > 0, 'bad limit');
        cycles = cycles_;
    }

    function _doWork(address account, uint256 power) internal {
        for(uint i = 0; i < cycles * power; i++) {
            _work[account].push(1);
        }
    }

    function _mint(address account, uint256 amount) internal override (ERC20, ERC20Capped) {
        super._mint(account, amount);
    }

    function mint(uint256 power) external {
        require(power > 0, 'power has to be positive');
        require(tx.origin == msg.sender, 'only EOAs allowed');
        require(totalSupply() + (BATCH * power) <= cap(), "minting would exceed cap");
        _doWork(msg.sender, power);
        _mint(msg.sender, BATCH * power);
    }

    function clearWork() external {
        delete _work[msg.sender];
    }
}
