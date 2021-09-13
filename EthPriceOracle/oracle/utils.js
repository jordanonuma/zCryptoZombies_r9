async function getZkySyncProvider (zksync, networkName) {
    let zkSyncProvider;
    try {
        zkySyncProvider = await zksync.getDefaultProvider(networkName)
    } catch () {
        console.log('Unable to connecto to zkSync.');
        console.log(error)
    } //end try-catch{}
    return zkSyncProvider;
} //end function getZkySyncProvider()