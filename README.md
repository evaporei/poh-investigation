# poh-investigation

This repository gathers multiple information on the POH determinism issue for The Graph Network.

Each folder contains a mini `README.md` with relevant information.

## Hypothesis A

Since indexer `0x365507a4eef5341cf00340f702f7f6e74217d96e` failed at block `12063620`, one possibility was that all indexers should also have stopped at the same block, and perhaps they were able to proceed because of the bug introduced in `v0.25.0` of `graph-node`, where restarting the `index-node` could cause a failed subgraph to skip the failed block.

At first I've used the [debug forking tool](https://thegraph.com/docs/en/developer/subgraph-debug-forking/) locally pointing a specific deployment in the Hosted Service (`QmYzsCjrVwwXtdsNm3PZVNziLGmb9o513GUzkq5wwhgXDT`). And since it failed consistently at that block, the hypothesis seemed to be confirmed. Even more when I've locally removed the patch introduced in `v0.25.2` that fixed the issue, so that the subgraph could continue normally.

However **unfortunately** the issue was related to the debug forking tool itself, because once I've deployed the graft to the Hosted Service at block `12063615` (5 blocks prior to where it failed), the subgraph continued indexing normally.

> Note: I'll create a separate issue to the debug forking tool bug.

### References

- subgraph graft
  - [manifest file](https://github.com/evaporei/poh-investigation/blob/main/graft-subgraph/subgraph0.yaml)
  - [Hosted Service page](https://thegraph.com/hosted-service/subgraph/evaporei/poh0)
- block
  - [etherscan page](https://etherscan.io/block/12063620)
  - [trace_filter JSON-RPC response](https://github.com/evaporei/poh-investigation/blob/main/trace-filter/toAddress0xB81384.json)

## Hypothesis B

As mentioned by @azf20 before, one thing that doesn't make any sense is that somehow there was a state change in block `13112568`. To investigate that I've deployed a subgraph that used the same base deployment as before (`QmYzsCjrVwwXtdsNm3PZVNziLGmb9o513GUzkq5wwhgXDT`) at block `13112565` (three blocks prior to where the ghost change was). As seen in the logs below (taken from the Hosted Service), no change was observed in the desired block.

```
2022-05-23 12:33:33	
May 23 15:33:33.972 DEBG Starting block stream, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: SubgraphInstanceManager
2022-05-23 12:33:34	
May 23 15:33:34.029 INFO Scanning blocks [13112566, 13112566], range_size: 1, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.029 DEBG Requesting logs for blocks [13112566, 13112566], contract 0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb, 3 events, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.029 DEBG Requesting logs for blocks [13112566, 13112566], contract 0x988b3a538b618c7a603e1c11ab82cd16dbe28069, 1 events, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.029 DEBG Requesting traces for block 13112566, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.104 DEBG Found 0 relevant block(s), sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.116 DEBG Requesting 0 block(s), sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.170 INFO Scanning blocks [13112567, 13112576], range_size: 10, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.170 DEBG Requesting logs for blocks [13112567, 13112576], contract 0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb, 3 events, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.170 DEBG Requesting logs for blocks [13112567, 13112576], contract 0x988b3a538b618c7a603e1c11ab82cd16dbe28069, 1 events, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:34	
May 23 15:33:34.170 DEBG Requesting traces for blocks [13112567, 13112576], sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:37	
May 23 15:33:37.261 DEBG Flushing 17 logs to Elasticsearch, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: SubgraphInstanceManager
2022-05-23 12:33:53	
May 23 15:33:53.893 DEBG Flushing 1 logs to Elasticsearch, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe
2022-05-23 12:33:53	
May 23 15:33:53.928 DEBG Flushing 8 logs to Elasticsearch, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe
2022-05-23 12:33:53	
May 23 15:33:53.929 DEBG Flushing 2 logs to Elasticsearch, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe
2022-05-23 12:33:59	
May 23 15:33:59.199 DEBG Received 1 traces for blocks [13112567, 13112576], sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:59	
May 23 15:33:59.199 DEBG Found 0 relevant block(s), sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:59	
May 23 15:33:59.208 DEBG Requesting 0 block(s), sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:59	
May 23 15:33:59.264 INFO Scanning blocks [13112577, 13112676], range_size: 100, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:59	
May 23 15:33:59.265 DEBG Requesting logs for blocks [13112577, 13112676], contract 0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb, 3 events, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
2022-05-23 12:33:59	
May 23 15:33:59.265 DEBG Requesting logs for blocks [13112577, 13112676], contract 0x988b3a538b618c7a603e1c11ab82cd16dbe28069, 1 events, sgd: 303076, subgraph_id: QmSWM35ustHMZamHU4kMtzzfhJmS2q2nZXFGywcKmbWqDe, component: BlockStream
```

I've also done a JSON-RPC `trace_filter` request to confirm, and the only call found was to the function `executeTransactionList`, which isn't listed at the subgraph's [`callHandler`s manifest](https://github.com/Proof-Of-Humanity/proof-of-humanity-web/blob/master/subgraph/subgraph.template.yaml#L37).

So it's still isn't clear how did multiple indexers saw a change for the given block, other than a badly handled re-org.

### References

- [`executeTransactionList` call on Etherscan](https://etherscan.io/tx/0x3fcfbf2c92a4196d19fc005f50489efa077157be992e56e6d3262bda595abbac)
- subgraph graft
  - [manifest file](https://github.com/evaporei/poh-investigation/blob/main/graft-subgraph/subgraph1.yaml)
  - [Hosted Service page](https://thegraph.com/hosted-service/subgraph/evaporei/poh1)
- block
  - [etherscan page](https://etherscan.io/block/13112568)
  - [trace_filter JSON-RPC response](https://github.com/evaporei/poh-investigation/blob/main/trace-filter/toAddress0xC814F8.json)
