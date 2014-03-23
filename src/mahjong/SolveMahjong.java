package mahjong;

import gps.GPSEngine;
import gps.SearchStrategy;
import gps.api.GPSProblem;

/**
 * Created by jugutier on 19/03/14.
 */
public class SolveMahjong {
    public static void main(String[] args) {
        long startTime = System.currentTimeMillis();
        GPSEngine engine = new MahjongGPSEngine();
        GPSProblem problem = new MahjongGPSProblem();

        engine.engine(problem, SearchStrategy.BFS);

        long endTime   = System.currentTimeMillis();
        long totalTime = endTime - startTime;
        System.out.println("Elapsed time: " + (totalTime/1000.0));
    }
}
