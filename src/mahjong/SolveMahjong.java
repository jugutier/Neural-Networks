package mahjong;

import gps.GPSEngine;
import gps.SearchStrategy;
import gps.api.GPSProblem;

/**
 * Created by jugutier on 19/03/14.
 */
public class SolveMahjong {
    public static void main(String[] args) {
        System.out.println("hi!");
        GPSEngine engine = new MahjongGPSEngine();
        GPSProblem problem = new MahjongGPSProblem();

        engine.engine(problem, SearchStrategy.DFS);
    }
}
