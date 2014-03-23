package mahjong;

import gps.GPSEngine;
import gps.SearchStrategy;
import gps.api.GPSProblem;

import java.util.Scanner;

/**
 * Created by jugutier on 19/03/14.
 */
public class SolveMahjong {
    public static void main(String[] args) {
        long startTime = System.currentTimeMillis();
        GPSEngine engine = new MahjongGPSEngine();
        GPSProblem problem = new MahjongGPSProblem();

        SearchStrategy strategy = null;
        Scanner scan = new Scanner(System.in);

        do {
            System.out.println("Choose a strategy: ");
            String line = scan.nextLine();
            if (line.toUpperCase().contains("DFS")) {
                strategy = SearchStrategy.DFS;
            } else if (line.toUpperCase().contains("BFS")) {
                strategy = SearchStrategy.BFS;
            } else {
                System.out.println("That is not a valid strategy. Try again.\n");
            }
        } while (strategy == null);

        engine.engine(problem, strategy);

        long endTime   = System.currentTimeMillis();
        long totalTime = endTime - startTime;
        System.out.println("Elapsed time: " + (totalTime/1000.0));
    }
}
