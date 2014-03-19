package mahjong;

import gps.api.GPSState;

import java.util.Stack;

/**
 * Created by jugutier on 18/03/14.
 */
public class MahjongGPSState implements GPSState {
    public MahjongBoard board;
    MahjongGPSState(int matrix[][]){
        this.board = new MahjongBoard(matrix);
    }
    @Override
    public boolean compare(GPSState state) {
        MahjongGPSState mState = ((MahjongGPSState)state);
        return board.equals(mState.board);
    }

    class  MahjongBoard{
        int matrix[][] ;
        MahjongBoard(int matrix[][]){
            matrix = matrix;
        }
        @Override
        public boolean equals(Object o) {
            //TODO implment!
            return super.equals(o);
        }
    }
}
