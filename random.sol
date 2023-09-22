// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract DamnVulnerableContract is ERC20, Ownable {
    mapping(address => uint) public balances;
    address public someOracle;
    address[] users;
    constructor(uint256 initialSupply, address _someOracle) ERC20("SolidityScan", "SCN") public {
        _mint(msg.sender, initialSupply);
        someOracle = _someOracle;
    }
    function mint(address _account, uint256 _amount) external {
        _mint(_account, _amount);
    } 
    function deposit(address _to) external payable {
        balances[_to] += msg.value;
        users.push(_to);
    }
    function withdraw(uint _amount) public {
    require(address(this).balance == 10 ether, "This will probably throw due to incorrect logic");
        if(balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value:_amount}("");
                if(result) {
                    _amount;
                }
            balances[msg.sender] -= _amount;
        }
    }
    function fetchPrice() public returns (bytes memory) {
        (bool success, bytes memory data) = someOracle.call{gas: 
5000}(abi.encodeWithSignature("priceFeed(uint256)", 123));
        return data;
    }
    function calcFunc(uint256 _a, uint256 _b) external pure returns (uint256){
        return (_a + _b)*100000000;
    }
    function payRewards() external onlyOwner {
        for (uint256 i = 0; i < users.length; i++) {
            transfer(users[i], balances[users[i]]);
        }
    }
}
