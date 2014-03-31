package mahjong;

import gps.BoardType;
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
        do{
            GPSEngine engine = new MahjongGPSEngine();
            GPSProblem problem = new MahjongGPSProblem();
            SearchStrategy strategy = null;
            BoardType boardType = null;
            System.out.println("Welcome to mahjongSolver.\nYou can type exit at any moment.");
            try{
                boardType = defineBoard();
                problem.setBoardType(boardType);
                strategy = defineStrategy();
                if (strategy == SearchStrategy.GREEDY || strategy == SearchStrategy.AStar) {
                    Heuristic heuristic = defineHeuristic();
                    problem.setHeuristic(heuristic);
                }
            }catch (RuntimeException e){
                System.out.println("Exit successful.");
                System.exit(1);
            }

            long startTime = System.currentTimeMillis();

            engine.engine(problem, strategy);

            long endTime = System.currentTimeMillis();
            long totalTime = endTime - startTime;
            System.out.println("Elapsed time: " + (totalTime / 1000.0)+"\n\n");
        }while (true);
    }

    private static SearchStrategy defineStrategy() {
        SearchStrategy strategy = SearchStrategy.NONE;
        Scanner scan = new Scanner(System.in);

        do {
            System.out.println("Choose a strategy: ");
            System.out.println("(You can type help to get possible options)");
            String input = scan.nextLine().toUpperCase();
            if (input.contains("EXIT") || input.contains("QUIT")) {
                throw new RuntimeException();
            }else if (input.contains("DFS")) {
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
            } else if(input.contains("HELP")){
                System.out.println("Possible options:");
                StringBuffer sBuff = new StringBuffer();
                for(SearchStrategy s:SearchStrategy.values()){
                    sBuff.append(s+",");
                }
                System.out.println(sBuff);
            } else{
                System.out.println("That is not a valid strategy. Try again, or type help for options.\n");
            }
        } while (strategy == SearchStrategy.NONE);

        return strategy;
    }

    private static Heuristic defineHeuristic() {
        Heuristic heuristic = Heuristic.NONE;
        Scanner scan = new Scanner(System.in);

        do {
            System.out.println("Choose an heuristic: ");
            System.out.println("(You can type help to get possible options)");
            String input2 = scan.nextLine().toUpperCase();

            if (input2.contains("EXIT") || input2.contains("QUIT")) {
                throw new RuntimeException();
            }else if (input2.equalsIgnoreCase("ONE")) {
                heuristic = Heuristic.ONE;
            } else if (input2.contains("TWO")) {
                heuristic = Heuristic.TWO;
            }else if (input2.contains("HELP")) {
                System.out.println("Possible options:");
                StringBuffer sBuff = new StringBuffer();
                for(Heuristic h:Heuristic.values()){
                    sBuff.append(h+",");
                }
                System.out.println(sBuff);
            } else {
                System.out.println("That is not a valid heuristic. Try again, or type help for options.\n");
            }
        } while (heuristic == Heuristic.NONE);

        return heuristic;
    }

    private static BoardType defineBoard(){
        BoardType bt = BoardType.NONE;
        Scanner scan = new Scanner(System.in);

        do {
            System.out.println("Choose a board: ");
            System.out.println("(You can type help to get possible options)");
            String input3 = scan.nextLine().toUpperCase();

            if (input3.contains("EXIT") || input3.contains("QUIT")) {
                throw new RuntimeException();
            }else if (input3.equalsIgnoreCase("ONE")) {
                bt = BoardType.ONE;
            } else if (input3.contains("TWO")) {
                bt = BoardType.TWO;
            }else if (input3.contains("THREE")) {
                bt = BoardType.THREE;
            }else if (input3.contains("FOUR")) {
                bt = BoardType.FOUR;
            }else if (input3.contains("FIVE")) {
                bt = BoardType.FIVE;
            }else if (input3.contains("HELP")) {
                System.out.println("Possible options:");
                StringBuffer sBuff = new StringBuffer();
                for(BoardType b:BoardType.values()){
                    sBuff.append(b+",");
                }
                System.out.println(sBuff);
            } else {
                System.out.println("That is not a valid board. Try again, or type help for options.\n");
            }
        } while (bt == BoardType.NONE);

        return bt;
    }
}