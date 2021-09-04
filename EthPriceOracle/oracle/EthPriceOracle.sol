pragma solidity 0.5.0;
import "openzeppelin-solidity/contracts/ownership/Ownable.sol"; //file path may not be exact
import "openzeppelin-solidity/contracts/access/Roles.sol"; //file path may not be exact
import "./CallerContractInterface.sol"; //file path may not be exact

contract EthPriceOracle {
    using Roles for Roles.Role;
    Roles.Role private owners;
    Roles.Role private oracles;

    uint private randNonce = 0;
    uint private modulus = 1000;
    mapping(uint256=>bool) pendingRequests;
    event GetLatestEthPriceEvent(address callerAddress, uint id);
    event SetLatestEthPriceEvent(uint256 ethPrice, address callerAddress);

    constructor (address _owner) public {
        owners.add(_owner);
    } //end constructor()
    
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

        //Instantiates with user-defined address.
        CallerContractInterface callerContractInstance;
        callerContractInstance = CallerContractInterface(_callerAddress);

        //Calls callback() and sends front end a notification
        callerContractInstance.callback(_ethPrice, _id);
        emit SetLatestEthPriceEvent(_ethPrice, _callerAddress);

    } //end function setLatestEthPrice()
} //end contract EthPriceOracle{}