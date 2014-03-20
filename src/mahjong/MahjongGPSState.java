package mahjong;

import gps.api.GPSState;


import java.awt.*;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;

/**
 * Created by jugutier on 18/03/14.
 */
public class MahjongGPSState implements GPSState {
    public MahjongBoard board;
    public List<Point> playables;
    MahjongGPSState(int matrix[][]){
        this.board = new MahjongBoard(matrix);
        playables = board.getPlayables();

    }
    @Override
    public boolean compare(GPSState state) {
        MahjongGPSState mState = ((MahjongGPSState)state);
        return board.equals(mState.board);
    }

    class  MahjongBoard{
        int matrix[][] ;
        MahjongBoard(int matrix[][]){
            this.matrix = matrix;
        }
        @Override
        public boolean equals(Object o) {
            boolean ret = Arrays.equals(matrix,((MahjongBoard) o).matrix);
            return ret;
        }
        public List<Point> getPlayables(){
            List<Point> playables = new LinkedList<Point>();

            for (int i = 0; i < board.matrix.length; i++){
                for(int j = 0; j<board.matrix[i].length;j++){//the first available
                    if(matrix[i][j] != 0){
                        playables.add(new Point(i,j));
                        break;
                    }
                }
                for(int k = board.matrix[i].length-1; k>0;k--){//the last available
                    if(matrix[i][k] != 0){
                        playables.add(new Point(i,k));
                        break;
                    }
                }
            }
            return playables;
        }
    }
}
