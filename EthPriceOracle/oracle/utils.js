async function getZkySyncProvider (zksync, networkName) {
    let zkSyncProvider
    try {
        zkSyncProvider = await zksync.getDefaultProvider(networkName)
    } catch () {
        console.log('Unable to connect to zkSync.')
        console.log(error)
    } //end try-catch{}
    return zkSyncProvider
} //end function getZkySyncProvider()