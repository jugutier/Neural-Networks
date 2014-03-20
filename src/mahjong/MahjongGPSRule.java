package mahjong;

import gps.api.GPSRule;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

import java.awt.*;

/**
 *  A tile is playable, if and only if
 * either its left side or its right side
 * does not touch any other tile.
 * Created by jugutier on 19/03/14.
 */
public class MahjongGPSRule implements GPSRule{
    @Override
    public Integer getCost() {
        return 1;
    }

    @Override
    public String getName() {
        return "play";
    }

    @Override
    public GPSState evalRule(GPSState state) throws NotAppliableException {
        MahjongGPSState mState = (MahjongGPSState) state;
        if(mState.playables.size()==0){
            return mState;
        }
       int[][] rBoard =  ((MahjongGPSState) state).board.matrix.clone();
        Point p = mState.playables.get(0);
        int currentValue = rBoard[p.x][p.y];
        for(Point point : mState.playables){
            if(rBoard[point.x][point.y] == currentValue){
                rBoard[p.x][p.y]=0;
                rBoard[point.x][point.y] = 0;//remove both tiles
            }
        }

        return new MahjongGPSState(rBoard);
    }
}
