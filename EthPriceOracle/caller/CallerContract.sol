pragma solidity 0.5.0;
import "./EthPriceOracleInterface.sol";

contract CallerContract {
    EthPriceOracleInterface private EthPriceOracle;
    address private oracleAddress;
    function setOracleInstanceAddress(address _oracleInstanceAddress) public {
        oracleAddress = _oracleInstanceAddress;
    } //end function setOracleInstanceAddress()
} //end CallerContract{}