// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Dijkstra {
    uint constant INF = 2**256 - 1; // 用于初始化距离为无限大
    uint private nodeCount;
    // 表示
    mapping(uint => uint[]) private adjList;
    // 存距离
    mapping(uint => mapping(uint => uint)) private dist;
    uint[] path;
    uint[] PathResult;
    struct Edge {
        uint to;
        uint weight;
    }
    constructor(uint256 NodeCount) {
        nodeCount = NodeCount;
    }
    // 添加一条边
    function addEdge(uint u, uint v, uint w) public {
        adjList[u].push(v);
        adjList[v].push(u);
        dist[u][v] = w;
        dist[v][u] = w;
    }

    // 求起点到所有点的最短距离
    function serchDistance(uint start) public view returns (uint[] memory) {
        // 记录找到这个点与原点的距离是否是最小
        uint[] memory Final = new uint[](nodeCount); 
        // 起点到各点的距离
        uint[] memory startToDistance = new uint[](nodeCount); 
        // 初始化距离和Final数组
        for (uint i = 0; i < nodeCount; i++) {
            startToDistance[i] = INF; // 初始化距离为无限大
            Final[i] = 0;
        }
        startToDistance[start] = 0; // 起点到自己的距离为0

        // 找离起点最近，但没确定最短路径的点，且更新距离disdance,通过两层for，即可实现
        for (uint i = 0; i < nodeCount-1; i++) {
            uint minVertex = minDist(startToDistance, Final);
            Final[minVertex] = 1;
            for (uint j = 0; j < adjList[minVertex].length; j++) {
                uint v = adjList[minVertex][j];
                uint w = dist[minVertex][v];
                if (Final[v]==0 && startToDistance[minVertex] != INF && startToDistance[minVertex]+w < startToDistance[v]) {
                    startToDistance[v] = startToDistance[minVertex] + w;
                }
            }
        }

        return startToDistance;
    }

    // 找原点到目标点的最短距离经过的路径
    function serchPath(uint start, uint end) public returns (uint[] memory) {
        uint[] memory startToDistance = new uint[](nodeCount);
        uint[] memory prevNode = new uint[](nodeCount); 
        uint[] memory Final = new uint[](nodeCount);
        delete path;
        delete PathResult;
        for (uint i = 0; i < nodeCount; i++) {
            startToDistance[i] = INF;
            prevNode[i] = nodeCount; // 初始化前一个点为nodeCount
            Final[i] = 0;
        }
        startToDistance[start] = 0;

        // 依次找到距离起点最近的未确定最短距离的点，并更新它连接的点的距离和前一个点
        for (uint i = 0; i < nodeCount-1; i++) {
            uint minVertex = minDist(startToDistance, Final);
            Final[minVertex] = 1;
            for (uint j = 0; j < adjList[minVertex].length; j++) {
                uint v = adjList[minVertex][j];
                uint w = dist[minVertex][v];
                if (Final[v]==0 && startToDistance[minVertex] != INF &&startToDistance[minVertex]+w < startToDistance[v]) {
                    startToDistance[v] = startToDistance[minVertex] + w;
                    prevNode[v] = minVertex;
                }
            }
        }

        
    //   从终点找到原点经过了哪些点
        uint x = end;
        while (x != start) {
            path.push(x);
            x = prevNode[x];
        }
        path.push(start);
        
        for (uint i = path.length-1; i>0; i--) {
           uint val=path[i];
           PathResult.push(val);
           PathResult.push(path[0]);

        }

        return PathResult;

    }

    // 从原点到此点距离最短且未被标记已找到的点
    function minDist(uint[] memory startToDistance, uint[] memory Final) private pure returns (uint) {
        uint minVal = INF;
        uint minVertex = 0;
        for (uint i = 0; i < startToDistance.length; i++) {
            if (Final[i]==0 && startToDistance[i] < minVal) {
                minVal = startToDistance[i];
                minVertex = i;
            }
        }
        return minVertex;
    }
}
