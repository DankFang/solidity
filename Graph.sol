// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract Undigraph {
    // TODO 数据结构自己设计
    mapping(uint256 => bool) visited;
    uint256[] stack;
    uint256[] queue;
    uint256[] DFSresult;
    uint256[] allNodeId;
    uint256[] BFSResult;
    uint256[] path;
    uint256[] pathID;
    uint256[] shortPath;
    uint256[] pathResult;

    uint256 route;
    struct Node {
        uint256 nodeId;
        string name;
        uint256[] neighbors; // 存储与该节点相邻的节点的ID
    }
    struct Graph {
        mapping(uint256 => Node) nodes;
        uint256 nodeCount;
    }
    Graph private graph;

    function addVertext(uint256 nodeId, string memory nodeName) external {
        require(nodeId != 0, "Node ID should not be zero.");
        require(graph.nodes[nodeId].nodeId == 0, "Node already exists.");
        graph.nodes[nodeId] = Node(nodeId, nodeName, new uint256[](0));
        graph.nodeCount++;
        visited[nodeId] = false;
        allNodeId.push(nodeId);
    }

    function addEdge(uint256 vertext1, uint256 vertext2) external {
        // TODO构建一个图，vertext1与vertext表示这是两个顶点中有条边
        require(vertext1 != 0 && vertext2 != 0, "vertext should not be zero.");
        require(
            graph.nodes[vertext1].nodeId != 0 &&
                graph.nodes[vertext2].nodeId != 0,
            "Node does not exist."
        );
        graph.nodes[vertext1].neighbors.push(vertext2);
        graph.nodes[vertext2].neighbors.push(vertext1);
    }

    // function getNode(uint nodeId) public view returns (uint, string memory, uint[] memory) {
    //     Node storage node = graph.nodes[nodeId];
    //     return (node.nodeId, node.name, node.neighbors);
    // }

    function BFS(uint256 start) external returns (uint256[] memory) {
        // TODO

        // 先把之前遍历过的全部重置
        setFaulse();
        queue.push(start);
        visited[start] = true;
        while (queue.length != 0) {
            uint256 FirstElement = queue[0];
            delete queue[0];
            for (uint256 i = 0; i < queue.length - 1; i++) {
                queue[i] = queue[i + 1];
            }
            queue.pop();
            BFSResult.push(FirstElement);
            BFSserch(FirstElement);
        }
        return BFSResult;
    }

    function DFS(uint256 start) external returns (uint256[] memory) {
        // TODO
        // 先把之前遍历过的全部重置
        setFaulse();
        stack.push(start);
        visited[start] = true;
        while (stack.length != 0) {
            uint256 topElement = stack[stack.length - 1];
            stack.pop();
            DFSresult.push(topElement);
            DFSSerch(topElement);
        }
        return DFSresult;
        
    }

    function ShortestPath(uint256 start) external returns (uint256[] memory) {
        // TODO
        setFaulse();
        queue.push(start);
        pathID.push(start);
        visited[start] = true;
        // 
        path.push(route);
        while (queue.length != 0) {
            uint256 FirstElement = queue[0];
            delete queue[0];
            for (uint256 i = 0; i < queue.length - 1; i++) {
                queue[i] = queue[i + 1];
            }
            queue.pop();
            route+=1;
            BFSserch(FirstElement);
        }
        
        for (uint8 id=1;id<=pathID.length;id++){
            for (uint256 i = 0; i < pathID.length; i++){
            if(pathID[i]==id){
                pathResult.push(path[i]);
            }
        
        }
        }
        
        return pathResult;
    }

    function DFSSerch(uint256 start) private { 
        for (uint256 i = 0; i < graph.nodes[start].neighbors.length; i++) {
            uint256 v = graph.nodes[start].neighbors[i];
            if (!visited[v]) {
                stack.push(v);
                visited[v] = true;
            }
        }
    }

    function BFSserch(uint256 start) private {
        // visited[start] = true;  
        for (uint256 i = 0; i < graph.nodes[start].neighbors.length; i++) {
            uint256 v = graph.nodes[start].neighbors[i];
            if (!visited[v]) {
                queue.push(v);
                pathID.push(v);
                visited[v] = true;
                path.push(route);
            }
        }
    }

    function setFaulse() private {
        for (uint256 i = 0; i < graph.nodeCount; i++) {
            // path.push(route);
            uint256 currentID = allNodeId[i];
            visited[currentID] = false;
        }
    }
}
