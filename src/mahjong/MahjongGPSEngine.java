package mahjong;

import gps.GPSEngine;
import gps.GPSNode;
import gps.SearchStrategy;
import gps.exception.InvalidSearchStrategyException;

/**
 * Created by jugutier on 19/03/14.
 */
public class MahjongGPSEngine extends GPSEngine {

    @Override
    public void addNode(GPSNode node) {
        if(this.strategy == SearchStrategy.BFS){
            open.add(node);
            //System.out.println("BFS");
        }else if(this.strategy == SearchStrategy.DFS){
            open.add(0,node);
            //System.out.println("DFS");
        }else if(this.strategy == SearchStrategy.IP){

        }else if(this.strategy == SearchStrategy.AStar){
            throw new RuntimeException("Unimplemented strategy");
        }else{
            throw new InvalidSearchStrategyException();
        }
    }
}
