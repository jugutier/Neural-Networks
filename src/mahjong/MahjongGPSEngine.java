package mahjong;

import gps.GPSEngine;
import gps.GPSNode;
import gps.SearchStrategy;
import gps.exception.InvalidSearchStrategyException;

import java.util.LinkedList;
import java.util.List;

/**
 * Created by jugutier on 19/03/14.
 */
public class MahjongGPSEngine extends GPSEngine {
    int maxDepth = 1;

    @Override
    public void addNode(GPSNode node) {
        System.out.println(strategy);
        switch (strategy){
            case BFS:
                open.add(node);
                break;
            case DFS:
                open.add(0,node);
                break;
            case ID:
                if(node.getDepth() <= this.maxDepth){
                    open.add(0,node);
                }else{
                    maxDepth += 1;
                    List<GPSNode> temp = new LinkedList<GPSNode>();
                    temp.add(open.get(open.size()-1));
                    open = temp;
                    closed = new LinkedList<GPSNode>();
                }
                break;
            case GREEDY:
                break;
            case AStar:
                throw new RuntimeException("Unimplemented strategy");
            default:
                throw new InvalidSearchStrategyException();
        }
    }
}
