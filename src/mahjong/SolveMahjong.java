package mahjong;

import gps.GPSEngine;
import gps.Heuristic;
import gps.SearchStrategy;
import gps.api.GPSProblem;

import java.util.Scanner;

/**
 * Created by jugutier on 19/03/14.
 */
public class SolveMahjong {

    public static void main(String[] args) {
        GPSEngine engine = new MahjongGPSEngine();
        GPSProblem problem = new MahjongGPSProblem();

        SearchStrategy strategy = defineStrategy();

        if (strategy == SearchStrategy.GREEDY || strategy == SearchStrategy.AStar) {
            Heuristic heuristic = defineHeuristic();
            problem.setHeuristic(heuristic);
        }

        long startTime = System.currentTimeMillis();

        engine.engine(problem, strategy);

        long endTime = System.currentTimeMillis();
        long totalTime = endTime - startTime;
        System.out.println("Elapsed time: " + (totalTime / 1000.0));
    }

    private static SearchStrategy defineStrategy() {
        SearchStrategy strategy = SearchStrategy.NONE;
        Scanner scan = new Scanner(System.in);

        do {
            System.out.println("Choose a strategy: ");
            String input = scan.nextLine().toUpperCase();
            if (input.contains("DFS")) {
                strategy = SearchStrategy.DFS;
            } else if (input.contains("BFS")) {
                strategy = SearchStrategy.BFS;
            } else if (input.contentEquals("ID")) {
                strategy = SearchStrategy.ID;
            } else if (input.contains("ASTAR")) {
                strategy = SearchStrategy.AStar;
            } else if (input.contains("ID")) {
                strategy = SearchStrategy.ID;
            } else if (input.contains("GREEDY")) {
                strategy = SearchStrategy.GREEDY;
            } else {
                System.out.println("That is not a valid strategy. Try again.\n");
            }
        } while (strategy == SearchStrategy.NONE);

        return strategy;
    }

    private static Heuristic defineHeuristic() {
        Heuristic heuristic = Heuristic.NONE;
        Scanner scan = new Scanner(System.in);

        do {
            System.out.println("Choose an heuristic: ");
            String input2 = scan.nextLine().toUpperCase();

            if (input2.contains("ONE")) {
                heuristic = Heuristic.ONE;
            } else if (input2.contains("TWO")) {
                heuristic = Heuristic.TWO;
            } else {
                System.out.println("That is not a valid heuristic. Try again.\n");
            }
        } while (heuristic == Heuristic.NONE);

        return heuristic;
    }
}
