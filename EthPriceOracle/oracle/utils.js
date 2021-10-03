async function getZkSyncProvider (zksync, networkName) {
    let zkSyncProvider
    try {
        zkSyncProvider = await zksync.getDefaultProvider(networkName)
    } catch (error) {
        console.log('Unable to connect to zkSync.')
        console.log(error)
    } //end try-catch{}
    return zkSyncProvider
} //end function getZkySyncProvider()

async function getEthereumProvider (ethers, networkName) {
    let ethersProvider
    try {
        // eslint-disable-next-line new-cap
        ethersProvider = new ethers.getDefaultProvider(networkName)
    } catch (error) {
        console.log('Could not connect to Rinkeby')
        console.log(error)
    } //end try-catch{}
    return ethersProvider
} //end function getEthereumProvider()

async function initAccount (rinkebyWallet, zkSyncProvider, zksync) {
    const zkSyncWallet = await zksync.Wallet.fromEthSigner(rinkebyWallet, zkSyncProvider)
    return zkSyncWallet
} //end function initAccount()

async function registerAccount (wallet) {
    console.log(`Registering the ${wallet.address()} account on zkSync`)
    if (!await wallet.isSigningKeySet()) {
        if (await wallet.getAccountId() === undefined) {
            throw new Error('Unknown account')
        } //end if()

        const changePubkey = await wallet.setSigningKey()
        await changePubkey.awaitReceipt()
    } //end if()
} //end function registerAccount()

async function depositToZkSync (zkSyncWallet, token, amountToDeposit, tokenSet) {
    const deposit = await zkSyncWallet.depositToSyncFromEthereum({
        depositTo: zkSyncWallet.address(),
        token: token,
        amount: tokenSet.parseToken(token, amountToDeposit)
    })
    try {
        await deposit.awaitReceipt()
    } catch (error) {
        console.log('Error while awaiting confirmation from the zkSync operators.')
        console.log(error)
    }
} //end function depositToZkSync()

async function transfer (from, toAddress, amountToTransfer, transferFee, token, zksync, tokenSet) {
    const closestPackableAmount = zksync.utils.closestPackableTransactionAmount(tokenSet.parseToken(BigNumber))
    const closestPackableFee = zksync.utils.closestPackableTransactionFee(tokenSet.parseToken(BigNumber))
    const transfer = await from.syncTransfer({
        to: toAddress,
        token: token,
        amount: closestPackableAmount,
        fee: closestPackableFee
    }) //end from.syncTransfer()
    const transferReceipt = await transfer.awaitReceipt()
    console.log('Got transfer receipt.')
    console.log(transferReceipt)
} //end function transfer()

async function getFee (transactionType, address, token, zkSyncProvider, ethers) {
    const feeInWei = await zkSyncProvider.getTransactionFee(transactionType, address, token)
    return ethers.utils.formatEther(feeInWei.totalFee.toString())
} //edn function getFee()

async function withdrawToEthereum (wallet, amountToWithdraw, withdrawalFee, token, zksync, ethers) {
    const closestPackableAmount = zksync.utils.closestPackableTransactionAmount(ethers.utils.parseEther(amountToWithdraw))
    const closestPackableFee = zksync.utils.closestPackableTransactionFee(ethers.utils.parseEther(withdrawalFee))
    const withdraw = await wallet.withdrawFromSyncToEthereum({
        ethAddress: wallet.address(),
        token: token,
        amount: closestPackableAmount,
        fee: closestPackableFee
    })
    await withdraw.awaitVerifyReceipt()    
  
    console.log('ZKP verification is complete')
} //end function withdrawToEthereum()

async function displayZkSyncBalance(wallet, tokenSet) {
    const state = await wallet.getAccountState()
    const committedBalances = state.committed.balances()
    const verifiedBalances = state.verified.balances()

    for (const property in committedBalances) {
        console.log(`Committed ${property} balance for ${wallet.address()}: ${tokenSet.formatToken(property, committedBalances[property])}`)
    } //end for(committedBalances)
    for (const property in verifiedBalances) {
        console.log(`Verified ${property} balance for ${wallet.address()}: ${tokenSet.formatToken(property, verifiedBalances[property])}`)
    } //end for(verifiedBalances)
} //end function displayZkSyncBalance()