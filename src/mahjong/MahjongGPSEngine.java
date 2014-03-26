package mahjong;

import gps.GPSEngine;
import gps.GPSNode;
import gps.exception.InvalidSearchStrategyException;

import java.util.Collections;
import java.util.Comparator;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by jugutier on 19/03/14.
 */
public class MahjongGPSEngine extends GPSEngine {
    int maxDepth = 1;

    @Override
    public void addNode(GPSNode node) {
        switch (strategy) {
            case BFS:
                open.add(node);
                break;
            case DFS:
                open.add(0, node);
                break;
            case ID:
                if (node.getDepth() <= this.maxDepth) {
                    open.add(0, node);
                } else {
                    maxDepth += 1;
                    List<GPSNode> temp = new LinkedList<GPSNode>();
                    temp.add(open.get(open.size() - 1));
                    open = temp;
                    closed = new LinkedList<GPSNode>();
                }
                break;
            case GREEDY:
                open.add(node);
                Collections.sort(open, new Comparator<GPSNode>() {
                    @Override
                    public int compare(GPSNode gpsNode, GPSNode gpsNode2) {
                        return problem.getHValue(gpsNode.getState()) - problem.getHValue(gpsNode2.getState());
                    }
                });
                break;
            case AStar:
                open.add(node);
                Collections.sort(open, new Comparator<GPSNode>() {
                    /*Elegir para expansion el nodo con menor f.

                         Si dos nodos tienen igual valor de f elegir el nodo con

                        menor valor de h.*/
                    @Override
                    public int compare(GPSNode gpsNode, GPSNode gpsNode2) {
                        int h1 = problem.getHValue(gpsNode.getState());
                        int f1 = gpsNode.getCost() + h1;
                        int h2 = problem.getHValue(gpsNode2.getState());
                        int f2 = gpsNode2.getCost() + h2;

                        return  f1-f2 !=0?f1-f2:h1-h2;
                    }
                });
                break;
            default:
                throw new InvalidSearchStrategyException();
        }
    }
}
