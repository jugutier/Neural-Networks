package mahjong;

import gps.api.GPSRule;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

import java.awt.*;

/**
 * A tile is playable, if and only if
 * either its left side or its right side
 * does not touch any other tile.
 * <p/>
 * A rule is to play 2 tiles of the symbol indicated by the rule.
 * <p/>
 * Created by jugutier on 19/03/14.
 */
public class MahjongGPSRule implements GPSRule {
    int symbol;

    public MahjongGPSRule(int symbol) {
        this.symbol = symbol;
    }

    @Override
    public Integer getCost() {
        return 1;
    }

    @Override
    public String getName() {
        return "Play tile symbol: " + symbol;
    }

    @Override
    public String toString() {
        return "Play tile symbol: " + symbol;
    }

    @Override
    public GPSState evalRule(GPSState state) throws NotAppliableException {
        MahjongGPSState mState = (MahjongGPSState) state;
        if (mState.playables.size() == 0) {
            return mState;
        }

        //int[][] rBoard =  ((MahjongGPSState) state).board.matrix.clone();
        int[][] matrix = ((MahjongGPSState) state).board.matrix;
        int[][] rBoard = new int[matrix.length][matrix[0].length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                rBoard[i][j] = matrix[i][j];
            }
        }

        //Point p = mState.playables.get(0);
        for (Point p : mState.playables) {
            int currentValue = rBoard[p.x][p.y];
            if (currentValue == this.symbol) {
                for (Point point : mState.playables) {
                    if (!(point.x == p.x && point.y == p.y)) {
                        if (rBoard[point.x][point.y] == currentValue) {
                            rBoard[p.x][p.y] = 0;
                            rBoard[point.x][point.y] = 0;//remove both tiles
                            return new MahjongGPSState(rBoard);
                        }
                    }
                }
            }
        }
        throw new NotAppliableException();

        //return new MahjongGPSState(rBoard);
    }

}
