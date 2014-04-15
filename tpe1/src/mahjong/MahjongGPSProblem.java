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
    /*
    Level: 0
        | 1 | 2 |
        | 1 | 2 |
    Level: 1
        | 3 | 4 |
        | 4 | 3 |
     */

    /*int[][][] board5 = {{{0,0},{0,0},{5,13},{9,5},{0,0},{9,7},{1,29},{0,0},{0,0}},
        {{10,26},{11,5},{12,21},{13,16},{0,0},{15,6},{16,10},{3,31},{4,22}},
        {{13,14},{14,11},{0,0},{0,0},{0,0},{0,0},{0,0},{15,4},{17,30}},
        {{18,24},{12,25},{19,2},{20,23},{0,0},{21,27},{22,21},{17,22},{3,29}},
        {{0,0},{0,0},{20,10},{2,28},{0,0},{18,19},{23,23},{0,0},{0,0}},
        {{12,3},{24,6},{25,1},{7,9},{0,0},{21,27},{10,9},{3,26},{22,1}},
        {{8,19},{20,24},{0,0},{0,0},{0,0},{0,0},{0,0},{7,14},{24,23}},
        {{12,28},{7,5},{1,19},{2,8},{0,0},{20,4},{4,30},{26,2},{13,31}}};*/

    int[][][] board5 = {{{0,0},{0,0},{13,5},{5,9},{0,0},{7,9},{29,1},{0,0},{0,0}},
            {{26,10},{5,11},{21,12},{16,13},{0,0},{6,15},{10,16},{31,3},{22,4}},
            {{14,13},{11,14},{0,0},{0,0},{0,0},{0,0},{0,0},{4,15},{30,17}},
            {{24,18},{25,12},{2,19},{23,20},{0,0},{27,21},{21,22},{22,17},{29,3}},
            {{0,0},{0,0},{10,20},{28,2},{0,0},{19,18},{23,23},{0,0},{0,0}},
            {{3,12},{6,24},{1,25},{9,7},{0,0},{27,21},{9,10},{26,3},{1,22}},
            {{19,8},{24,20},{0,0},{0,0},{0,0},{0,0},{0,0},{14,7},{23,24}},
            {{28,12},{5,7},{19,1},{8,2},{0,0},{4,20},{30,4},{2,26},{31,13}}};

    int[][][] board6 = {{{1,2},{3,5},{2,4}},{{5,4},{3,1},{6,8}},{{1,7},{7,1},{6,8}}};
    int[][][] board7 = {{{1,2},{3,5},{2,4}},{{5,4},{3,1},{6,6}},{{1,7},{7,1},{8,8}}};

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
            case SIX:
                initBoard = board6;
                lastSymbol = 8;
                break;
            case SEVEN:
                initBoard = board7;
                lastSymbol = 8;
                break;
            case NONE:
            default:
                throw new IllegalArgumentException("Invalid board type.");
        }
    }


}
