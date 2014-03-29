package mahjong;

import gps.BoardType;
import gps.Heuristic;
import gps.api.GPSProblem;
import gps.api.GPSRule;
import gps.api.GPSState;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jugutier on 18/03/14.
 */
public class MahjongGPSProblem implements GPSProblem {

    Heuristic heuristic = Heuristic.NONE;
    int lastSymbol;
    int [][]initBoard= null;

    int[][] board1 = {{1,4,5,5,4},{2,3,3,2,1}};
    int[][] board2 = {{1,4,5,5,4},{2,3,3,2,1},{0,5,2,2,5}};
    int[][] board3 = {{1, 4, 5, 5, 4, 6}, {2, 3, 3, 2, 6, 1}, {0, 5, 2, 0, 2, 5}, {3, 3, 1, 6, 6, 1}};

    @Override
    public GPSState getInitState() {
        MahjongGPSState initState = new MahjongGPSState(initBoard);
        initState.setLastSymbol(lastSymbol);
        System.out.println("Problem to solve: \n" + initState);
        return initState;
    }

    @Override
    public GPSState getGoalState() {
        int[][] goalBoard = new int[initBoard.length][initBoard[0].length];
        MahjongGPSState goalState = new MahjongGPSState(goalBoard);

        return goalState;
    }

    @Override
    public List<GPSRule> getRules() {
        List<GPSRule> rules = new ArrayList<GPSRule>();

        for (int i = 1; i <= this.lastSymbol; i++)
            rules.add(new MahjongGPSRule(i));

        //Collections.shuffle(rules);
        return rules;
    }

    @Override
    public Integer getHValue(GPSState state) {
        switch (heuristic) {
            case ONE:
                return Integer.MAX_VALUE - ((MahjongGPSState) state).playables.size();
            case TWO:
                return ((MahjongGPSState) state).playablePairs();
            case NONE:
            default:
                throw new IllegalArgumentException("Invalid heuristic.");
        }
    }

    @Override
    public void setHeuristic(Heuristic myHeuristic) {
        heuristic = myHeuristic;
    }

    @Override
    public void setBoardType(BoardType boardType) {
        switch (boardType) {
            case ONE:
                initBoard = board1;
                lastSymbol = 5;
                break;
            case TWO:
                initBoard = board2;
                lastSymbol = 5;
                break;
            case THREE:
                initBoard = board3;
                lastSymbol = 6;
                break;
            case NONE:
            default:
                throw new IllegalArgumentException("Invalid board type.");
        }
    }


}
