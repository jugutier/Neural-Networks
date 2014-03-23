package mahjong;

import gps.api.GPSProblem;
import gps.api.GPSRule;
import gps.api.GPSState;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jugutier on 18/03/14.
 */
public class MahjongGPSProblem implements GPSProblem {
    int lastSymbol;

    @Override
    public GPSState getInitState() {
        //int[][] initBoard = {{1,4,5,5,4},{2,3,3,2,1}};
        //this.lastSymbol = 5;
        //int[][] initBoard = {{1,4,5,5,4},{2,3,3,2,1},{0,5,2,2,5}};
        //this.lastSymbol = 5;
        int[][] initBoard = {{1,4,5,5,4,6},{2,3,3,2,6,1},{0,5,2,0,2,5},{3,3,1,6,6,1}};
        this.lastSymbol = 6;

        MahjongGPSState initState = new MahjongGPSState(initBoard);
        System.out.println("Problem to solve: \n" + initState);
        return initState;
    }

    @Override
    public GPSState getGoalState() {
        int[][] goalBoard = new int[3][5];
        MahjongGPSState goalState = new MahjongGPSState(goalBoard);

        return goalState;
    }

    @Override
    public List<GPSRule> getRules() {
        List<GPSRule> rules = new ArrayList<GPSRule>();

        for(int i = 1; i <= this.lastSymbol; i++)
            rules.add(new MahjongGPSRule(i));
        return rules;
    }

    @Override
    public Integer getHValue(GPSState state) {
        return ((MahjongGPSState)state).playables.size();
    }
}
