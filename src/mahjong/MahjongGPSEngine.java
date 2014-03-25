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
        if(this.strategy == SearchStrategy.BFS){
            open.add(node);
            //System.out.println("BFS");
        }else if(this.strategy == SearchStrategy.DFS){
            open.add(0,node);
            //System.out.println("DFS");
        }else if(this.strategy == SearchStrategy.ID){
            if(node.getDepth() <= this.maxDepth){
                open.add(0,node);
            }else{
                maxDepth += 1;
                List<GPSNode> temp = new LinkedList<GPSNode>();
                temp.add(open.get(open.size()-1));
                open = temp;
                closed = new LinkedList<GPSNode>();
            }
        }else if(this.strategy == SearchStrategy.AStar){
            throw new RuntimeException("Unimplemented strategy");
        }else{
            throw new InvalidSearchStrategyException();
        }
    }
}
