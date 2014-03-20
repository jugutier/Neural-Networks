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
    @Override
    public GPSState getInitState() {
        int[][] initBoard = {{1,4,5,5,4},{2,3,3,2,1}};

        MahjongGPSState initState = new MahjongGPSState(initBoard);

        return initState;
    }

    @Override
    public GPSState getGoalState() {
        int[][] goalBoard = new int[2][5];
        MahjongGPSState goalState = new MahjongGPSState(goalBoard);

        return goalState;
    }

    @Override
    public List<GPSRule> getRules() {
        List<GPSRule> rules = new ArrayList<GPSRule>();
        rules.add(new MahjongGPSRule());
        return rules;
    }

    @Override
    public Integer getHValue(GPSState state) {
        return ((MahjongGPSState)state).playables.size();
    }
}
