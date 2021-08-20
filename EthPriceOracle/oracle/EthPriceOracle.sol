pragma solidity 0.5.0;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol"; //file path may not be exact
import "./CallerContractInterface.sol"; //file path may not be exact

contract EthPriceOracle is Ownable {
    uint private randNonce = 0;
    uint private modulus = 1000;
    mapping(uint256=>bool) pendingRequests;
    event GetLatestEthPriceEvent(address callerAddress, uint id);
    event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);
    
    function getLatestEthPrice() public returns(uint256) {
        randNonce++;
        uint id = uint(keccak256(abi.encodePacked(now, msg.sender, randNonce))) % modulus;

        //adds to pending request array
        pendingRequests[id] = true;
        //fires notification to front end
        emit GetLatestEthPriceEvent(msg.sender, id);
        //returns request ID back to function caller
        return id;
    } //end function getLatestEthPrice()

    function setLatestEthPrice(uint256 _ethPrice, address _callerAddress, uint256 _id) public onlyOwner {
        require(pendingRequests[_id], "This request is not in my pending list.");
        delete pendingRequests[_id];
    } //end function setLatestEthPrice()
} //end contract EthPriceOracle{}