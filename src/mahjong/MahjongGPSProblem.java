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
    int [][][]initBoard= null;

    int[][][] board1 = {{{1},{4},{5},{5},{4}},{{2},{3},{3},{2},{1}}};
    int[][][] board2 = {{{1},{4},{5},{5},{4}},{{2},{3},{3},{2},{1}},{{0},{5},{2},{2},{5}}};
    int[][][] board3 = {{{1}, {4}, {5}, {5}, {4}, {6}}, {{2}, {3}, {3}, {2}, {6}, {1}},
            {{0}, {5}, {2}, {0}, {2}, {5}}, {{3}, {3}, {1}, {6}, {6}, {1}}};
    int[][][] board4 = {{{1,3},{2,4}},{{1,4},{2,3}}};

    int[][][] board5 = {{{0,0,5,9,0,9,1,0,0},{10,11,12,13,0,15,16,3,4},{13,14,0,0,0,0,0,15,17},{18,12,19,20,0,21,22,17,3},{0,0,20,2,0,18,23,0,0},{12,24,25,7,0,21,10,3,22},{8,20,0,0,0,0,0,7,24},{12,7,1,2,0,20,4,26,13}},
            {{0,0,13,5,0,7,29,0,0},{26,5,21,16,0,6,10,31,22},{14,11,0,0,0,0,0,4,30},{24,25,2,23,0,27,21,22,29},{0,0,10,28,0,19,23,0,0},{3,6,1,9,0,27,9,26,1},{19,24,0,0,0,0,0,14,23},{28,5,19,8,0,4,30,2,31}}};
    @Override
    public GPSState getInitState() {
        MahjongGPSState initState = new MahjongGPSState(initBoard);
        initState.setLastSymbol(lastSymbol);
        System.out.println("Problem to solve: \n" + initState);
        return initState;
    }

    @Override
    public GPSState getGoalState() {
        int[][][] goalBoard = new int[initBoard.length][initBoard[0].length][initBoard[0][0].length];
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
            case FOUR:
                initBoard = board4;
                lastSymbol = 4;
                break;
            case FIVE:
                initBoard = board5;
                lastSymbol = 31;
                break;
            case NONE:
            default:
                throw new IllegalArgumentException("Invalid board type.");
        }
    }


}
